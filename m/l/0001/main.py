import subprocess

from flask import Flask, Response

app = Flask(__name__)


@app.route("/", methods=["GET"])
def run_check():
    try:
        process = subprocess.run(["just", "check"], text=True, capture_output=True)
        return Response(process.stdout, mimetype="text/plain", status=200)
    except Exception as e:
        return Response(f"Error: {str(e)}", mimetype="text/plain", status=500)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
