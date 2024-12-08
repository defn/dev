import sys

from hello import hello


def main():
    if len(sys.argv) < 2:
        print("Usage: python cli.py <name>")
        sys.exit(1)

    name = sys.argv[1]
    print(hello(name))


if __name__ == "__main__":
    main()
