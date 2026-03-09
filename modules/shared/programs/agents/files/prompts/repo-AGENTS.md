# Repository Guidelines

## Project Structure & Module Organization
This repository manages macOS (`nix-darwin`) system and Home Manager configuration.
- Root entrypoints: `flake.nix`, `flake.lock`, `darwin.nix`, `makefile`.
- Darwin user config: `modules/darwin/home.nix`, `modules/darwin/configuration.nix`.
- Shared modules: `modules/shared/configuration.nix`.
- Program-specific modules: `modules/shared/programs/<tool>/default.nix` (for example `git`, `node`, `terraform`, `nix`).
- Static assets for modules live under `files/` (for example `modules/shared/programs/terraform/files/config.tfrc`).

Keep new functionality in the closest existing module. Prefer extending `modules/shared/programs/<tool>/` over adding root-level files.

## Build, Test, and Development Commands
- `make init`: first-time setup using `nix-darwin` flake target `.#ohyeong-geun`.
- `make build`: apply configuration (`darwin-rebuild switch --flake '.#ohyeong-geun' --show-trace`).
- `make fmt`: format all Nix files with `nix fmt` (`nixfmt-rfc-style`).
- `nix flake check`: run flake evaluation checks before opening a PR.

Run commands from repository root.

## Coding Style & Naming Conventions
- Language: Nix.
- Formatting: always run `make fmt` before commit.
- Indentation: 2 spaces; keep attribute sets and lists readable and stable.
- File naming: use `default.nix` inside module directories; use lowercase tool directories (`aws`, `tmux`, `kubernetes`).
- Keep modules focused: one concern per module (package/tool/service).

## Testing Guidelines
There is no dedicated unit test suite in this repo. Validation is configuration evaluation and successful system switch:
1. `make fmt`
2. `nix flake check`
3. `make build`

For risky changes, verify affected tools after rebuild (for example `git --version`, `terraform version`).

## Commit & Pull Request Guidelines
Recent history follows short, prefix-based messages such as `feat:`, `fix:`, `chore:`, `config:`, and `pkg:`.
- Use imperative, scoped messages (example: `feat(node): add pnpm config`).
- Keep commits focused and atomic.
- PRs should include: purpose, key changed paths, validation commands run, and any manual post-apply steps.
- Link related issues/tasks and attach screenshots only for UI/app-level changes (usually not needed here).

## Security & Configuration Tips
- Do not commit secrets, tokens, or private keys. Keep only public artifacts (for example `public.key`) in-repo.
- Review external package/module additions for trust and maintenance risk.
