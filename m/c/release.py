#!/usr/bin/env python

import os
import base64
import sys
import re

def process_line(line):
    # Split the line into filename and base64 encoded string
    filename, encoded_data = line.split(' ', 1)

    # Prefix the filename
    filename = os.path.join('../k/r', filename)

    # Create a directory with the filename if it doesn't exist
    os.makedirs(os.path.dirname(filename), exist_ok=True)

    # Decode the base64 string
    decoded_data = base64.b64decode(encoded_data)

    # Transform the text using the sed substitution
    transformed_data = re.sub(r'{{', '{{ "{{" }}', decoded_data.decode('utf-8'))

    # Write the transformed data to the corresponding file
    with open(filename, 'w') as file:
        file.write(transformed_data)

if __name__ == "__main__":
    # Process each line from stdin
    for line in sys.stdin.readlines():
        process_line(line.strip())
