# python -mvenv venv
# venv/bin/pip install -r requirements.txt
# venv/bin/marimo run --watch --headless --no-token notebook.py

import subprocess

import marimo

app = marimo.App()


@app.cell
def _():
    import marimo as mo

    return (mo,)


@app.cell
def _(mo):
    slider = mo.ui.slider(4, 100)
    return (slider,)


@app.cell(hide_code=False)
def _(mo, slider):
    import subprocess

    result = subprocess.run(
        f'bash -c "echo \\"$(uname -a) hello ' + str(slider.value) + '\\""',
        shell=True,
        capture_output=True,
        text=True,
    )
    mo.md(
        f"""
        shell output: {result.stdout.strip()}
        {"##" + "🍃" * slider.value}
        """
    )
    return
