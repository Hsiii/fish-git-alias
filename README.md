# fish-git-alias

Shared Fish abbreviations for Git workflows.

## What belongs here

This repo is the shared layer.
Keep only reusable interactive shell behavior here, such as:

- `abbr` definitions
- interactive shell helpers
- prompt/session behavior that should be shared across machines

Do not keep machine-specific settings here, such as:

- `PATH` entries
- `BUN_INSTALL`
- editor paths
- per-machine tool locations

Those belong in your real local Fish config at `~/.config/fish/config.fish`.

## Why the shared config is interactive-only

Fish loads `config.fish` for both interactive and non-interactive sessions.
This repo wraps its abbreviations in:

```fish
if status is-interactive
    ...
end
```

That keeps prompt-only features out of scripts and non-interactive commands like `fish -c '...'`.

## Local setup

Add this to your real Fish config:

```fish
source /Users/hsi/Documents/Projects/Archive/fish-git-alias/config.fish
```

Then keep your local-only environment setup below it, for example:

```fish
fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path ~/.local/bin

set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin
```

## Updating

Edit the shared aliases in this repo, then open a new Fish session or run:

```fish
source /Users/hsi/Documents/Projects/Archive/fish-git-alias/config.fish
```

To pick up new changes locally.

## Why not source from GitHub

Sourcing a remote raw file on shell startup is possible, but it is a worse default because it adds:

- startup latency
- a network dependency
- remote code execution on every shell launch
- failure modes when GitHub is unavailable

The local clone approach is faster, safer, and more predictable.
