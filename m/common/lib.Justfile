# Start a simple HTTP server
# Description: Launches Python's built-in HTTP server on specified port
# Dependencies: python3
# Outputs: HTTP server serving current directory
http-server *port:
    python -m http.server {{ port }}
