# PIDI

Repository for the TOFHub modular project.

## Current loader setup

The loader expects the supplied modular package to be extracted in the executor workspace as `TOFHub/`, with `TOFHub/main.lua` at the root of that folder.

1. Download the `TOFHub.zip` package.
2. Extract it so the workspace contains `TOFHub/main.lua`, `TOFHub/core/`, `TOFHub/config/`, `TOFHub/features/`, `TOFHub/esp/`, and `TOFHub/ui/`.
3. Run `loader.lua`.

The original `TOFHub/main.lua` is the module manager: it uses `Hub.use("folder/Module")`, caches dependencies, starts the modules in its BOOT list, and supports unload cleanup.

## Important status

The loader has been adapted to the original modular entry point. The archive itself still needs to be added to this repository, and the loader has not been runtime-tested in Delta Executor. Until the archive is present here, download the original `TOFHub.zip` from the conversation attachment and extract it locally.
