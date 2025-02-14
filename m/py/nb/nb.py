import os
import marimo
from marimo._config.settings import GLOBAL_SETTINGS
from marimo._server.file_router import AppFileRouter
from marimo._server.model import SessionMode
from marimo._server.start import start
from marimo._server.tokens import AuthToken
from marimo._utils.marimo_path import MarimoPath

__generated_with = "0.10.19"
app = marimo.App()


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""Use colon syntax as a shortcut for **emojis** in your markdown.""")
    return


@app.cell
def _(mo):
    mo.md(r""":rocket: :smile:""")
    return


@app.cell
def _():
    import marimo as mo

    return (mo,)


if __name__ == "__main__":
    print("Current directory:", os.getcwd())
    os.chdir("/home/ubuntu/m/py/nb")

    GLOBAL_SETTINGS.YES = True
    GLOBAL_SETTINGS.DEVELOPMENT_MODE = True
    GLOBAL_SETTINGS.QUIET = False
    start(
        file_router=AppFileRouter.from_filename(MarimoPath(__file__)),
        development_mode=GLOBAL_SETTINGS.DEVELOPMENT_MODE,
        quiet=GLOBAL_SETTINGS.QUIET,
        host="127.0.0.1",
        port=None,
        proxy=None,
        headless=False,
        mode=SessionMode.RUN,
        include_code=True,
        ttl_seconds=None,
        watch=False,
        base_url="",
        allow_origins=["*"],
        auth_token=AuthToken(""),
        cli_args={},
        redirect_console_to_browser=False,
    )
