// @ts-check
// auto-generated: site.cue astro_config_mjs
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

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
  integrations: [sitemap()],
});
