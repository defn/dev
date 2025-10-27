import { defineCollection, z } from "astro:content";
import { docsLoader } from "@astrojs/starlight/loaders";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob } from "astro/loaders";

export const collections = {
  docs: defineCollection({ loader: docsLoader(), schema: docsSchema() }),
  aws: defineCollection({
    loader: glob({ pattern: "**/*.yaml", base: "./src/content/aws" }),
    schema: z.object({
      name: z.string(),
      account: z.string(),
      org: z.string(),
      id: z.string(),
      email: z.string().email(),
      sso_role: z.string(),
    }),
  }),
};
