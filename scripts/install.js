const assert = require("assert");
const childProcess = require("child_process");
const fs = require("fs-extra");
const path = require("path");
const { getAddonName, getDotaPath, isWsl } = require("./utils");

const resolveRealPath = filePath => {
    try {
        return fs.realpathSync(filePath);
    } catch (_) {
        return undefined;
    }
};

const isWslEnv = isWsl(process.env);

const isMountedWindowsPath = filePath => /^\/mnt\/[a-zA-Z]\//.test(filePath);

const toWindowsPath = filePath => {
    if (!isWslEnv) {
        return filePath;
    }

    try {
        return childProcess.execFileSync("wslpath", ["-w", filePath], { encoding: "utf8" }).trim();
    } catch (_) {
        return filePath;
    }
};

const createWindowsJunction = (sourcePath, targetPath) => {
    const sourceWin = toWindowsPath(sourcePath);
    const targetWin = toWindowsPath(targetPath);
    childProcess.execFileSync("cmd.exe", ["/c", "mklink", "/J", targetWin, sourceWin], {
        stdio: "inherit",
    });
};

(async () => {
    const dotaPath = await getDotaPath();
    if (dotaPath === undefined) {
        console.log("No Dota 2 installation found. Addon linking is skipped.");
        return;
    }

    const addonName = getAddonName();
    for (const directoryName of ["game", "content"]) {
        const sourceRoot = path.resolve(__dirname, "..", directoryName);
        const nestedSourcePath = path.join(sourceRoot, addonName);
        const sourcePath = fs.existsSync(nestedSourcePath) ? nestedSourcePath : sourceRoot;
        assert(fs.existsSync(sourcePath), `Could not find '${sourcePath}'`);

        const targetRoot = path.join(dotaPath, directoryName, "dota_addons");
        assert(fs.existsSync(targetRoot), `Could not find '${targetRoot}'`);

        const targetPath = path.join(targetRoot, addonName);
        if (fs.existsSync(targetPath)) {
            const sourceRealPath = resolveRealPath(sourcePath);
            const targetRealPath = resolveRealPath(targetPath);
            const isCorrect = sourceRealPath !== undefined && sourceRealPath === targetRealPath;
            if (isCorrect) {
                console.log(`Skipping '${targetPath}' since it already points to '${sourcePath}'`);
                continue;
            } else {
                throw new Error(`'${targetPath}' is already linked to another directory`);
            }
        }

        if (isWslEnv && isMountedWindowsPath(targetPath)) {
            createWindowsJunction(sourcePath, targetPath);
        } else {
            fs.symlinkSync(sourcePath, targetPath, "junction");
        }
        console.log(`Linked ${targetPath} -> ${sourcePath}`);
    }
})().catch(error => {
    console.error(error);
    process.exit(1);
});
