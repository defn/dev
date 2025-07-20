#!/usr/bin/env node

/**
 * ESRGAN Image Super-Resolution Processing Script
 * ==============================================
 * 
 * This script uses the ESRGAN (Enhanced Super-Resolution Generative Adversarial Networks)
 * model via Replicate API to upscale and enhance images. ESRGAN is particularly effective
 * at enhancing image details and reducing artifacts while increasing resolution.
 * 
 * Features:
 * - Image super-resolution with configurable scale factors
 * - Optional face enhancement for portraits
 * - Automatic file fetching and saving
 * - JSON metadata storage for processing results
 * 
 * Usage:
 *   node ersgan.mjs <image_id> [scale] [face_enhance]
 * 
 * Example:
 *   node ersgan.mjs photo001 4 true
 * 
 * Requirements:
 *   - REPLICATE_API_TOKEN environment variable
 *   - Input images available at configured URL endpoint
 *   - Write access to replicate/js/ and replicate/img/ directories
 */

import Replicate from "replicate";
import fs from "fs";
import fetch from "node-fetch";

/**
 * Initialize Replicate API client
 * Requires REPLICATE_API_TOKEN environment variable to be set
 * This token provides access to the Replicate cloud ML platform
 */
const replicate = new Replicate({
  auth: process.env.REPLICATE_API_TOKEN,
});

/**
 * Command line argument validation
 * Ensures at minimum the image ID is provided
 * Displays usage information if arguments are missing
 */
if (process.argv.length < 3) {
  console.error(
    "Usage: node ersgan.mjs <image_id> [scale] [face_enhance]",
  );
  console.error("Arguments:");
  console.error("  image_id     - Identifier for the image to process (required)");
  console.error("  scale        - Upscaling factor (default: 2, options: 2, 4)");
  console.error("  face_enhance - Enable face enhancement (default: false)");
  process.exit(1);
}

/**
 * Parse command line arguments with defaults
 * - imageId: Required identifier for the input image
 * - scale: Super-resolution scaling factor (2x or 4x)
 * - faceEnhance: Whether to apply specialized face enhancement
 */
const imageId = process.argv[2];
const scale = process.argv.length >= 4 ? parseInt(process.argv[3], 10) : 2;
const faceEnhance =
  process.argv.length >= 5 ? process.argv[4].toLowerCase() === "true" : false;

// Validate scale parameter
if (![2, 4].includes(scale)) {
  console.error("Error: Scale must be 2 or 4");
  process.exit(1);
}

/**
 * Construct source image URL
 * Uses a standardized URL pattern to locate input images
 * Images are expected to be in PNG format at the configured endpoint
 */
const imageUrl = `https://pc.tail3884f.ts.net/pub/t2/${imageId}.png`;

console.error("Processing image:", imageUrl);
console.error(`Parameters: scale=${scale}, face_enhance=${faceEnhance}`);

try {
  /**
   * Create ESRGAN prediction using Replicate API
   * 
   * Model Version: f121d640bd286e1fdc67f9799164c1d5be36ff74576ee11c803ae5b665dd46aa
   * This is the Real-ESRGAN model optimized for photo enhancement
   * 
   * Parameters:
   * - image: URL of the input image to enhance
   * - scale: Upscaling factor (2 = 2x resolution, 4 = 4x resolution)
   * - face_enhance: Enable specialized face enhancement algorithms
   */
  const prediction = await replicate.predictions.create({
    version: "f121d640bd286e1fdc67f9799164c1d5be36ff74576ee11c803ae5b665dd46aa",
    input: {
      image: imageUrl,
      scale: scale,
      face_enhance: faceEnhance,
    },
  });

  /**
   * Wait for prediction completion
   * This can take several minutes depending on image size and queue
   */
  console.error("Waiting for ESRGAN processing to complete...");
  const result = await replicate.wait(prediction);
  console.error("Processing completed successfully");

  /**
   * Save prediction metadata as JSON
   * Includes processing details, timestamps, and model information
   * Useful for debugging and tracking processing history
   */
  fs.writeFileSync(
    `replicate/js/${imageId}.json`,
    JSON.stringify(result, null, 2),
  );
  console.error(`Metadata saved to: replicate/js/${imageId}.json`);

  /**
   * Download and save the enhanced image
   * The output URL contains the processed high-resolution image
   * Save as PNG to preserve quality of the enhanced image
   */
  const outputUrl = result.output;
  console.error("Downloading enhanced image from:", outputUrl);
  
  const response = await fetch(outputUrl);
  if (!response.ok) {
    throw new Error(`Failed to fetch enhanced image: ${response.statusText}`);
  }

  const buffer = await response.buffer();
  const outputPath = `replicate/img/${imageId}.png`;
  fs.writeFileSync(outputPath, buffer);
  
  console.error(`Enhanced image saved to: ${outputPath}`);
  console.error(`Original size: ${imageUrl}`);
  console.error(`Enhanced with ${scale}x upscaling${faceEnhance ? ' and face enhancement' : ''}`);
} catch (error) {
  /**
   * Error handling for various failure scenarios:
   * - Network issues accessing input image or Replicate API
   * - Invalid API token or quota exceeded
   * - Model processing failures
   * - File system write permissions
   */
  console.error("Error during ESRGAN processing:", error.message);
  
  // Provide specific guidance for common errors
  if (error.message.includes('token')) {
    console.error("Check that REPLICATE_API_TOKEN environment variable is set correctly");
  } else if (error.message.includes('fetch')) {
    console.error("Check that the input image URL is accessible:", imageUrl);
  } else if (error.message.includes('ENOENT')) {
    console.error("Ensure replicate/js/ and replicate/img/ directories exist");
  }
  
  process.exit(1);
}
