// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import sitemap from "@astrojs/sitemap";

// https://astro.build/config
export default defineConfig({
  site: "https://defn.github.io",
  base: "/dev",
  trailingSlash: "always",
  build: {
    assets: "a",
  },
  vite: {
    server: {
      host: true,
      allowedHosts: [".defn.run"],
    },
    build: {
      rollupOptions: {
        onwarn(warning, warn) {
          // Suppress "unused import" warnings from Astro's internal modules
          if (
            warning.code === "UNUSED_EXTERNAL_IMPORT" &&
            warning.exporter?.includes("@astrojs/internal-helpers/remote")
          ) {
            return;
          }
          warn(warning);
        },
      },
    },
  },
  integrations: [
    sitemap({
      serialize(item) {
        // Remove lastmod to ensure reproducible builds
        delete item.lastmod;
        return item;
      },
    }),
    starlight({
      title: "ACUTE",
      customCss: [
        "@fontsource/roboto/400.css",
        "@fontsource/roboto/500.css",
        "@fontsource/roboto/700.css",
        "@fontsource-variable/roboto-mono",
        "./src/styles/custom.css",
      ],
      pagination: false,
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/defn/dev",
        },
      ],
      sidebar: [
        {
          label: "AWS Accounts",
          items: [{ label: "All Accounts", link: "/aws/" }],
        },
      ],
    }),
  ],
});
