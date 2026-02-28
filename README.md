# Quick guide

`npm install` - will install the needed dependencies. it'll also find your dota 2 installation and symlink the project there, so you can edit the project here and dota will automatically see the changes.

`npm run dev` - starts a process which will update the .js files whenever you change .ts files. Never edit the js files directly, update ts files and js files will update automatically (when you have `npm run dev` running). You can also run `npm run build` to compile ts files to js manually. You don't need to use `npm run dev` if you use `npm run launch`.

`npm run launch` - launches dota 2 tools and runs `npm run dev`. If dota is closed then `npm run dev` is stopped automatically

## From scratch

```sh
git clone <repo url>
cd <repo>
npm run install
npm run launch
# build maps in Hammer
# dota_launch_custom_game trollnelves2 classic
# edit TS files as needed
```
