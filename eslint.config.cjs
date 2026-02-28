const tsParser = require("@typescript-eslint/parser");
const tsPlugin = require("@typescript-eslint/eslint-plugin");
const stylistic = require("@stylistic/eslint-plugin");

module.exports = [
    {
        ignores: [
            "node_modules/**",
            "game/**",
            "**/*.d.ts",
            "content/trollnelves2/panorama/layout/custom_game/**/*.js",
        ],
    },
    {
        files: ["content/trollnelves2/panorama/**/*.ts"],
        languageOptions: {
            parser: tsParser,
            ecmaVersion: "latest",
            sourceType: "script",
        },
        plugins: {
            "@typescript-eslint": tsPlugin,
            "@stylistic": stylistic,
        },
        rules: {
            ...tsPlugin.configs.recommended.rules,
            curly: ["error", "all"],
            "@stylistic/quotes": ["error", "double", { avoidEscape: true }],
            "@stylistic/semi": ["error", "always"],
            "@typescript-eslint/ban-ts-comment": ["warn", { "ts-ignore": "allow-with-description" }],
            "@typescript-eslint/no-empty-function": "warn",

            // Migration-friendly defaults while converting legacy Panorama JS to TS.
            "@typescript-eslint/no-explicit-any": "off",
            "@typescript-eslint/no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
        },
    },
];
