// This script essentially just executes tsc --project <file> --watch
// But with some special handling for WSL as file watch doesn't work when the files are under windows filesystem (even if mounted as /mnt/c/...) but tsc is running from WSL

const { spawn } = require("child_process");
const fs = require("fs");
const path = require("path");
const { isWsl } = require("./utils");

const resolvePath = inputPath => {
    try {
        return fs.realpathSync(path.resolve(inputPath));
    } catch (_) {
        return path.resolve(inputPath);
    }
};

const isWindowsMountPath = filePath => filePath.startsWith("/mnt/");

const runTsc = ({ tsconfigPath, usePolling }) => {
    const npxCmd = process.platform === "win32" ? "npx.cmd" : "npx";
    const args = ["tsc", "--project", tsconfigPath, "--watch"];
    if (usePolling) {
        args.push("--watchFile", "dynamicPriorityPolling");
        args.push("--watchDirectory", "dynamicPriorityPolling");
    }
    return spawn(npxCmd, args, { stdio: "inherit" });
};

const main = ({ argv, env }) => {
    const tsconfigPath = argv[2];
    if (!tsconfigPath) {
        console.error("Usage: node scripts/dev.js <tsconfig-path>");
        process.exit(1);
    }

    const resolvedTsconfigPath = resolvePath(tsconfigPath);
    const usePolling = isWsl(env) && isWindowsMountPath(resolvedTsconfigPath);
    const tscProcess = runTsc({ tsconfigPath, usePolling });

    tscProcess.on("exit", code => {
        process.exit(code ?? 1);
    });
};

main({ argv: process.argv, env: process.env });
