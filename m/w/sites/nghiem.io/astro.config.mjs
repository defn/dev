// @ts-check
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import svelte from "@astrojs/svelte";

// https://astro.build/config
export default defineConfig({
  site: "https://nghiem.io",
  build: {
    assets: "a",
  },
  vite: {
    server: {
      allowedHosts: [".defn.run"],
    },
  },
  integrations: [sitemap(), tailwind({ applyBaseStyles: true }), svelte()],
});
