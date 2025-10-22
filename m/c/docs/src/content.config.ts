import { defineCollection, z } from "astro:content";
import { docsLoader } from "@astrojs/starlight/loaders";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob } from "astro/loaders";

export const collections = {
  docs: defineCollection({ loader: docsLoader(), schema: docsSchema() }),
  aws: defineCollection({
    loader: glob({ pattern: "**/*.json", base: "./src/content/aws" }),
    schema: z.object({
      name: z.string(),
      id: z.string(),
      email: z.string().email(),
      region: z.string().optional(),
      accountType: z.string().optional(),
      description: z.string().optional(),
    }),
  }),
};
