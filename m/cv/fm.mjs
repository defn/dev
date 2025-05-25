#!/usr/bin/env node

import { writeFile } from "fs/promises";
import Replicate from "replicate";
const replicate = new Replicate();

// Check if there is at least one command line argument provided
if (process.argv.length < 3) {
  console.error(
    "Usage: node script.js <swap_filename> <input_filename> <save_filename>",
  );
  process.exit(1);
}

// Get the command line arguments
const input = {
  swap_image: `https://penguin.tail3884f.ts.net/${process.argv[2]}`,
  input_image: `https://penguin.tail3884f.ts.net/${process.argv[3]}`,
};

const output = await replicate.run(
  "codeplugtech/face-swap:278a81e7ebb22db98bcba54de985d22cc1abeead2754eb1f2af717247be69b34",
  { input },
);
await writeFile(process.argv[4], output);
