// @ts-check
import { defineConfig } from "astro/config";

import svelte from "@astrojs/svelte";
import cloudflare from "@astrojs/cloudflare";

import tailwind from "@astrojs/tailwind";

// https://astro.build/config
export default defineConfig({
  output: "server",
  adapter: cloudflare({
    imageService: "cloudflare",
    platformProxy: {
      enabled: true,
    },
  }),
  integrations: [svelte(), tailwind()],
});
