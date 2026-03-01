const { spawn } = require("child_process");
const path = require("path");
const { getAddonName, getDotaPath, isWsl } = require("./utils");

(async () => {
    const dotaPath = await getDotaPath();
    const win64 = path.join(dotaPath, "game", "bin", "win64");

    // You can add any arguments there
    // For example `+dota_launch_custom_game ${getAddonName()} dota` would automatically load "dota" map
    const args = ["-novid", "-tools", "-addon", getAddonName()];
    const dota = spawn(path.join(win64, "dota2.exe"), args, {
        cwd: win64,
        stdio: "ignore",
    });

    let devProcess = null;

    const wsl = isWsl(process.env);

    const killProcessTree = (child) => {
        if (!child || child.exitCode !== null) {
            return;
        }
        if (process.platform === "win32") {
            spawn("taskkill", ["/PID", String(child.pid), "/T", "/F"]);
        } else {
            try {
                process.kill(-child.pid, "SIGTERM");
            } catch (_) {
                try {
                    child.kill("SIGTERM");
                } catch (_) {}
            }
        }
    };

    const startDev = () => {
        if (devProcess) {
            return;
        }
        const npmCmd = process.platform === "win32" ? "npm.cmd" : "npm";
        devProcess = spawn(npmCmd, ["run", "dev"], {
            stdio: "inherit",
            detached: process.platform !== "win32",
        });
    };

    dota.once("spawn", startDev);
    dota.once("exit", () => {
        killProcessTree(devProcess);
    });

    const shutdown = () => {
        killProcessTree(devProcess);
        if (wsl) {
            // WSL can't reliably signal Windows processes; taskkill the image instead.
            spawn("taskkill.exe", ["/IM", "dota2.exe", "/T", "/F"]);
        } else {
            killProcessTree(dota);
        }
        process.exit(0);
    };

    process.on("SIGINT", shutdown);
    process.on("SIGTERM", shutdown);
})().catch(error => {
    console.error(error);
    process.exit(1);
});
