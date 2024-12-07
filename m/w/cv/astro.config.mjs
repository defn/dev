// @ts-check
import { defineConfig } from "astro/config";

//import starlight from '@astrojs/starlight';
import mdx from "@astrojs/mdx";

// https://astro.build/config
export default defineConfig({
  integrations: [
    mdx(),
    //starlight({ title: 'My delightful docs site' }),
  ],
  build: {
    assets: "a",
  },
  legacy: {
    collections: true,
  },
});
