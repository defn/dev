// @ts-check
import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
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
  integrations: [sitemap(), tailwind({ applyBaseStyles: true })],
});
