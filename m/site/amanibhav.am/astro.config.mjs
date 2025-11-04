// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import svelte from "@astrojs/svelte";

// https://astro.build/config
export default defineConfig({
  site: "https://amanibhav.am",
  build: {
    assets: "a",
  },
  vite: {
    server: {
      allowedHosts: [".defn.run"],
    },
  },
  integrations: [sitemap(), svelte()],
});
