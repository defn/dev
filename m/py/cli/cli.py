import sys
from datetime import datetime

import cowsay
from py.goodbye.goodbye import goodbye
from py.hello.hello import hello
from rich import print


def main():
    name = sys.argv[1]
    print("Hello, [bold magenta]World[/bold magenta]!", ":vampire:", hello(name))
    print("Good-bye, [bold magenta]World[/bold magenta]!", ":vampire:", goodbye(name))


if __name__ == "__main__":
    main()
