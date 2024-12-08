import sys

import cowsay
from py.goodbye.goodbye import goodbye
from py.hello.hello import hello


def main():
    if len(sys.argv) < 2:
        print("Usage: python cli.py <name>")
        sys.exit(1)

    for f in sys.path:
        print(f)

    name = sys.argv[1]
    cowsay.cow(hello(name))
    cowsay.cow(goodbye(name))


if __name__ == "__main__":
    main()
