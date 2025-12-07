import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    ignores: ["node_modules/", "dist/"],
  },
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      parserOptions: {
        project: ["./tsconfig.json"],
      },
    },
    rules: {
      "@typescript-eslint/no-floating-promises": "error",
    },
  },
);
