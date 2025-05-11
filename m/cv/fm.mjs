#!/usr/bin/env node

import Replicate from "replicate";
import fs from "fs";
import fetch from "node-fetch";

// Create a Replicate instance using the API token from the environment variables
const replicate = new Replicate({
  auth: process.env.REPLICATE_API_TOKEN,
});

// Check if there is at least one command line argument provided
if (process.argv.length < 3) {
  console.error("Usage: node script.js <from_filename> <to_filename>");
  process.exit(1);
}

// Get the command line arguments
const imageFromId = process.argv[2];
const imageFromUrl = process.argv[3];
const imageToId = process.argv[4];
const imageToUrl = `https://pc.tail3884f.ts.net/pub/r2/${imageToId}.png`;

console.error("public from url :", imageFromUrl);
console.error("public to url :", imageToUrl);
try {
  // Run the Replicate model
  const prediction = await replicate.predictions.create({
    version: "c71604c00f0b74344fb50bb3c323f6089ed9defc229e02063cd3a5b59e081621",
    input: {
      image_from: imageFromUrl,
      image_to: imageToUrl,
    },
  });

  const result = await replicate.wait(prediction);

  // Write the JSON object to a file
  fs.writeFileSync(
    `fm/js/${imageFromId}-${imageToId}.json`,
    JSON.stringify(result, null, 2)
  );

  // Fetch the file from the .output URL and save it to a file
  const outputUrl = result.output;
  const response = await fetch(outputUrl);

  if (!response.ok)
    throw new Error(`Failed to fetch file: ${response.statusText}`);

  const buffer = await response.buffer();
  fs.writeFileSync(`fm/img/${imageFromId}-${imageToId}.png`, buffer);
} catch (error) {
  console.error("Error running the Replicate model:", error);
}
