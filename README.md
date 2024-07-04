# PNPM .modules.yaml storeDir issue

Minimal reproduction for https://github.com/pnpm/pnpm/issues/7727#issuecomment-2112613861

Error message:
`The modules directory at X will be removed and reinstalled from scratch. Proceed?`
`The modules directories will be removed and reinstalled from scratch. Proceed?`

code source: https://github.com/pnpm/pnpm/blob/84654bd2ad01f5473d50e8a630ff805726075c70/pkg-manager/get-context/src/index.ts#L351

Step to reproduce:

Define the store dir to the current path and install the dep

```bash
pnpm config set store-dir ./.pnpm-store
pnpm install
```

First check, the path is the right one

```bash
pnpm store path
/Users/random.name/dev/pnpm-modules-yaml-storedir/.pnpm-store/v3
```

Second check, the path in the .modules.yaml is the right one

```bash
cat node_modules/.modules.yaml | grep storeDir
storeDir: /Users/maxime.richard/dev/pnpm-modules-yaml-storedir/.pnpm-store/v3
```

Let's run the app via Docker now.

There is multiple way to start the container, docker compose up etc.. let's use the easier way

```bash
docker compose run --rm app sh
```

First check, the store is at the root, it's the righe one

```bash
pnpm store path
/app/.pnpm-store/v3
```

Second check, the path in the .modules.yaml is **NOT** the right one, it's wrong.

```bash
cat node_modules/.modules.yaml | grep storeDir
storeDir: /Users/maxime.richard/dev/pnpm-modules-yaml-storedir/.pnpm-store/v3
```

Install dep to see the error message

```bash
pnpm i
The modules directory at "/app/node_modules" will be removed and reinstalled from scratch. Proceed? (Y/n) · true
```

We have a miss watch between the storeDir and the pnpm store path, the absolute path is not well handle.

Expected: The local and the docker need to be the same, ie `storeDir: ./.pnpm-store/v3`, so that we can use the same storeDir on both side.
