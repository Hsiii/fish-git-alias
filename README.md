# fish-git-alias

`fish-git-alias` is a small shared Fish config that adds Git-focused abbreviations and helper functions for interactive shell use.

It is intended for people who want a lightweight personal Git workflow layer without mixing machine-specific environment setup into the same file.

## What this repo contains

The repo currently provides:

- a quiet Fish startup by overriding `fish_greeting`
- `git_default_branch`, a helper that resolves `origin/HEAD`
- Git abbreviations for switching branches, rebasing, force-pushing, branch cleanup, PR creation, and status checks
- `gz`, a reset helper with input validation and `--soft` / `--hard` modes

Everything is wrapped in:

```fish
if status is-interactive
    ...
end
```

That keeps these shortcuts out of non-interactive Fish runs such as scripts and `fish -c`.

## Install

Clone the repo somewhere stable, then source `config.fish` from your real Fish config:

```fish
source /Users/hsi/Documents/Projects/Archive/fish-git-alias/config.fish
```

Put machine-specific settings in `~/.config/fish/config.fish`, not in this repo. That includes things like:

- `PATH` changes
- tool install locations
- editor paths
- local environment variables

After editing the shared config, reload it with:

```fish
source /Users/hsi/Documents/Projects/Archive/fish-git-alias/config.fish
```

or open a new shell session.

## Command Reference

### Branching and syncing

- `gm`: switch to the remote default branch and pull
- `gw`: switch to an existing branch
- `gwc`: create and switch to a new branch
- `gwz`: switch back to the previous branch
- `gr`: fetch and rebase the current branch onto the remote default branch

### Pushing and pull requests

- `gf`: `git push --force-with-lease`
- `pr`: open GitHub PR creation in the browser with a branch-derived title

### Branch cleanup and inspection

- `gb`: list local branches sorted by most recent commit
- `gd`: delete a merged local branch
- `gD`: force-delete a local branch
- `gc`: prune remote-tracking refs and delete gone branches only when already merged into the default branch
- `gst`: show `git status`

`gc` behavior:

- runs `git fetch -p` first
- finds local branches whose upstream is marked `[gone]`
- deletes merged branches with `git branch -d`
- skips unmerged branches unless you pass `--force`
- never deletes the current branch

### Reset helper

`gz` resets `HEAD` by commit count and defaults to a soft reset of one commit.

Examples:

```fish
gz
gz 2
gz --hard
gz --hard 3
```

Behavior:

- default: `git reset --soft HEAD~1`
- `gz 3`: reset three commits
- `gz --hard 2`: hard-reset two commits
- invalid counts and conflicting flags are rejected

## Why keep this local

This repo is meant to be cloned and sourced locally instead of fetched from a remote URL on shell startup. That avoids:

- startup latency
- network dependency during shell launch
- remote code execution on every new session
- breakage when GitHub is unavailable
