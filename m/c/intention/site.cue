@experiment(aliasv2)
@experiment(explicitopen)

package intention

import (
	"strings"
)

site: [string]~(SITE,_): {
	port:          int | *4321
	wrangler_slug: strings.Replace(SITE, ".", "--", -1)

	mise_toml: """
		# auto-generated: site.cue mise_toml
		[env]
		APP_PORT = "\(port)"
		NODE_NO_WARNINGS = "1"
		"""

	package_json: """
		{
			"name": "\(SITE)",
			"description": "auto-generated: site.cue package_json",
			"version": "0.0.1",
			"private": true,
			"scripts": {
				"dev": "astro dev",
				"start": "astro dev",
				"build": "astro build",
				"preview": "astro preview",
				"astro": "astro"
			},
			"dependencies": {
				"@astrojs/check": "^0.9.6",
				"@astrojs/cloudflare": "^12.6.12",
				"@astrojs/sitemap": "^3.6.0",
				"@astrojs/starlight": "^0.37.0",
				"@astrojs/starlight-tailwind": "^4.0.2",
				"astro": "^5.16.3",
				"sharp": "^0.34.5",
				"tailwindcss": "^4.1.17",
				"typescript": "^5.9.3",
				"wrangler": "^4.51.0"
			}
		}
		"""

	tsconfig_json: """
		{
			"comment": "auto-generated: site.cue tsconfig_json",
			"extends": "astro/tsconfigs/strict",
			"include": [".astro/types.d.ts", "**/*"],
			"exclude": ["dist"]
		}
		"""

	astro_config_mjs: """
		// @ts-check
		// auto-generated: site.cue astro_config_mjs
		import { defineConfig } from "astro/config";
		import starlight from "@astrojs/starlight";
		import sitemap from "@astrojs/sitemap";

		// https://astro.build/config
		export default defineConfig({
			site: "https://\(SITE)",
			build: {
				assets: "a",
			},
			vite: {
				server: {
					allowedHosts: [".defn.run"],
				},
			},
			integrations: [
				sitemap(),
				starlight({
				title: "Docs with Tailwind",
				sidebar: [
					{
						label: "Guides",
						items: [{ label: "Example Guide", slug: "guides/example" }],
					},
					{
						label: "Reference",
						autogenerate: { directory: "reference" },
					},
				],
				customCss: ["./src/tailwind.css"],
				}),
			],
		});
		"""

	tailwind_config_mjs: """
		/* auto-generated: site.cue tailwind_config_mjs */
		import starlightPlugin from "@astrojs/starlight-tailwind";

		/** @type {import('tailwindcss').Config} */
		export default {
			content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
			plugins: [starlightPlugin()],
		};
		"""

	wrangler_toml: """
		# auto-generated: site.cue wrangler_toml
		name = "\(wrangler_slug)"

		compatibility_date = "2024-12-30"

		pages_build_output_dir = "dist"

		[env]
		production = {}
		"""
}
