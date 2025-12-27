#!/usr/bin/env python

import http.server
import json
import logging
import os
import random
import signal
import socket
import socketserver
import subprocess
import sys
import threading
import time
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import parse_qs, urlparse

server = None
port = None

clients = {}
lock = threading.Lock()

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def generate_client_id():
    return f"{int(time.time())}_{random.randint(1000, 9999)}"


class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200, "ok")
        self.end_headers()

    def do_GET(self):
        parsed_path = urlparse(self.path)
        query_params = urllib.parse.parse_qs(parsed_path.query)
        client_id = query_params.get("name", [generate_client_id()])[0]
        is_generated_id = "name" not in query_params

        if parsed_path.path == "/":
            self.handle_noc(client_id, is_generated_id)
        elif parsed_path.path == "/set":
            self.handle_set(query_params)
        elif parsed_path.path == "/poll":
            self.handle_poll(client_id)
        elif parsed_path.path in ["/select-no", "/select-yes"]:
            self.handle_yes_no(parsed_path)
        elif parsed_path.path == "/show-img":
            self.handle_show_img(parsed_path)
        elif parsed_path.path == "/help":
            self.handle_help()
        else:
            super().do_GET()

    def handle_help(self):
        # Create a dictionary for the response
        response_dict = {"hello": "world"}

        # Convert the dictionary into a JSON string
        response_json = json.dumps(response_dict)

        # Send the HTTP headers
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()

        # Write the JSON object to the response
        self.wfile.write(response_json.encode())

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header(
            "Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS"
        )
        self.send_header("Access-Control-Allow-Headers", "x-api-key, Content-Type")
        super().end_headers()

    def handle_yes_no(self, parsed_path):
        query = parse_qs(parsed_path.query)
        filename = query.get("filename", [None])[0]
        if filename:
            # Strip the leading "select-" from the directory if it exists
            directory = parsed_path.path.strip("/")
            if directory.startswith("select-"):
                directory = directory[7:]  # Remove the first 7 characters ("select-")

            # Touch the file in the current directory
            self.touch_file(directory, filename)

            # Determine the opposite directory and delete the file from it
            opposite_directory = (
                "no" if directory == "yes" else "yes" if directory == "no" else None
            )
            if opposite_directory:
                opposite_file_path = os.path.join(opposite_directory, filename)
                if os.path.exists(opposite_file_path):
                    try:
                        os.remove(opposite_file_path)
                    except OSError as e:
                        logging.error(
                            f"Failed to remove file {opposite_file_path}: {e}"
                        )
                        # Optionally, you can send a different response or log the failure
                        self.send_response(500)
                        self.end_headers()
                        self.wfile.write(
                            b"File touched, but failed to delete file from opposite directory"
                        )
                        return

            self.send_response(200)
            self.end_headers()  # End headers after sending response
            self.wfile.write(b"File touched and opposite file deleted if exists")
        else:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Missing filename parameter")

    def touch_file(self, directory, filename):
        if not os.path.exists(directory):
            os.makedirs(directory)
        file_path = os.path.join(directory, filename)
        with open(file_path, "a"):
            os.utime(file_path, None)

    def handle_show_img(self, parsed_path):
        query = parse_qs(parsed_path.query)
        image_url = query.get("url", [None])[0]
        if image_url:
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            html_content = f"""
            <html>
            <head>
                <style>
                    body {{
                        margin: 0;
                        padding: 0;
                        background-color: black;
                        height: 100vh;
                        overflow: hidden;
                    }}
                    img {{
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }}
                </style>
            </head>
            <body>
                <img src="{image_url}" alt="Image">
            </body>
            </html>
            """
            self.wfile.write(html_content.encode("utf-8"))
        else:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Missing url parameter")

    def handle_noc(self, client_id, is_generated_id):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header("Content-Security-Policy", "frame-ancestors 'self'")
        self.end_headers()
        self.wfile.write(
            bytes(self.create_main_page(client_id, is_generated_id), "utf8")
        )

    def handle_set(self, query_params):
        name = query_params.get("name", [""])[0]
        url = query_params.get("url", [""])[0]
        if name and url:
            with lock:
                clients[name] = url
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.send_header("Content-Security-Policy", "frame-ancestors 'self'")
            self.end_headers()
            self.wfile.write(
                bytes(
                    f"Name set to: {name}, URL set to: {url}<br><a href='/?name={name}'>Return to main page</a>",
                    "utf8",
                )
            )
        else:
            self.send_error(400, "Bad Request: Missing 'name' or 'url' parameter")

    def handle_poll(self, client_id):
        if client_id not in clients:
            clients[client_id] = "https://example.com"

        if client_id in clients:
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Security-Policy", "frame-ancestors 'self'")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            with lock:
                url = clients.get(client_id, "")
            self.wfile.write(bytes(json.dumps({"url": url}), "utf8"))
        else:
            self.send_error(404, f"Client ID not found: {client_id}")

    def create_main_page(self, client_id, is_generated_id):
        url = clients.get(client_id, "https://www.example.com")
        grid_html = self.create_grid_items() if is_generated_id else ""
        return f"""
<!DOCTYPE html>
<html>
<head>
    <title>URL Viewer</title>
    <style>
        .grid-container {{
            display: grid;
            grid-template-columns: auto auto auto auto;
            gap: 10px;
            padding: 10px;
        }}
        .grid-item {{
            padding: 20px;
            text-align: center;
            background-color: #f1f1f1;
            border: 1px solid #ddd;
            cursor: pointer;
        }}
       body, html {{
           margin: 0;
           padding: 0;
           width: 100%;
           height: 100%;
           overflow: hidden;
       }}
       iframe {{
           border: none;
           width: 100%;
           height: 100%;
       }}
    </style>
</head>
<body>
    {grid_html and f"<div class='grid-container'>{grid_html}</div>"}
    <iframe id="content-frame" src="{url}" style="width: 100%; height: 100vh; border: none;"></iframe>
    <script>
        function setName(name) {{
            location.href = "/?name=" + name;
        }}

        function pollServer() {{
            fetch("/poll?name={client_id}")
                .then(response => response.json())
                .then(data => {{
                    const iframe = document.getElementById('content-frame');
                    if (iframe.src !== data.url) {{ 
                        iframe.src = data.url;
                        console.info(data.url);
                    }}
                }})
                .catch(error => console.error('Error fetching update:', error));
        }}

        // Poll the server every 3 seconds
        setInterval(pollServer, 3000);

        document.querySelectorAll('.grid-item').forEach(item => {{
            item.addEventListener('click', event => {{
                setName(event.target.innerText);
            }});
        }});
    </script>
</body>
</html>
"""

    def create_grid_items(self):
        items = "0123456789abcdef"
        grid_html = ""
        for item in items:
            grid_html += f'<div class="grid-item">{item}</div>'
        return grid_html


def run():
    global server
    global port

    with socketserver.ThreadingTCPServer(
        ("0.0.0.0", 8112), CORSRequestHandler
    ) as httpd:
        server = httpd
        ip, port = httpd.server_address

        httpd.socket.setsockopt(
            socket.SOL_SOCKET, socket.SO_REUSEPORT | socket.SO_REUSEADDR, 1
        )
        logging.info(f"Serving on port http://0.0.0.0:{port}/")
        httpd.serve_forever()


def shutdown_server(signal_number, frame):
    logging.info("Shutting down server...")

    if server:
        server.shutdown()
        server.server_close()


if __name__ == "__main__":
    signal.signal(signal.SIGINT, shutdown_server)
    signal.signal(signal.SIGTERM, shutdown_server)
    server_thread = threading.Thread(target=run)
    server_thread.start()
