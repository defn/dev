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
  console.error(
    "Usage: node script.js <image_filename> [scale] [face_enhance]"
  );
  process.exit(1);
}

// Get the command line arguments
const imageId = process.argv[2];
const scale = process.argv.length >= 5 ? parseInt(process.argv[4], 10) : 2;
const faceEnhance =
  process.argv.length >= 6 ? process.argv[5].toLowerCase() === "true" : false;

// Construct the full image URL by appending the argument to the /pub/ path
const imageUrl = `https://pc.tail3884f.ts.net/pub/t2/${imageId}.png`;

console.error("public url :", imageUrl);
try {
  // Run the Replicate model
  const prediction = await replicate.predictions.create({
    version: "f121d640bd286e1fdc67f9799164c1d5be36ff74576ee11c803ae5b665dd46aa",
    input: {
      image: imageUrl,
      scale: scale,
      face_enhance: faceEnhance,
    },
  });

  const result = await replicate.wait(prediction);

  // Write the JSON object to a file
  fs.writeFileSync(
    `replicate/js/${imageId}.json`,
    JSON.stringify(result, null, 2)
  );

  // Fetch the file from the .output URL and save it to a file
  const outputUrl = result.output;
  const response = await fetch(outputUrl);

  if (!response.ok)
    throw new Error(`Failed to fetch file: ${response.statusText}`);

  const buffer = await response.buffer();
  fs.writeFileSync(`replicate/img/${imageId}.png`, buffer);
} catch (error) {
  console.error("Error running the Replicate model:", error);
}
