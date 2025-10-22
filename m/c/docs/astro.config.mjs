// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
  vite: {
    server: {
      host: true,
      allowedHosts: [".defn.run"],
    },
  },
  integrations: [
    starlight({
      title: "My Docs",
      customCss: [
        '@fontsource/roboto/400.css',
        '@fontsource/roboto/500.css',
        '@fontsource/roboto/700.css',
        '@fontsource-variable/roboto-mono',
        './src/styles/custom.css',
      ],
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/withastro/starlight",
        },
      ],
      sidebar: [
        {
          label: "Guides",
          items: [
            // Each item here is one entry in the navigation menu.
            { label: "Example Guide", slug: "guides/example" },
          ],
        },
        {
          label: "AWS Accounts",
          items: [{ label: "All Accounts", link: "/aws/" }],
        },
        {
          label: "Reference",
          autogenerate: { directory: "reference" },
        },
      ],
    }),
  ],
});
