from http.server import SimpleHTTPRequestHandler, HTTPServer

class NoListingHTTPRequestHandler(SimpleHTTPRequestHandler):
    def list_directory(self, path):
        self.send_error(403, "Directory listing not allowed")
        return None

if __name__ == "__main__":
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, NoListingHTTPRequestHandler)
    print("Starting server on port 8000")
    httpd.serve_forever()
