# fish-git-alias

A opinionated [Fish](https://fishshell.com/) config that adds Git-focused abbreviations and helper functions for interactive shell use.

## Combine with your own config

Clone the repo somewhere stable, then source the config from your local Fish config:

```fish
source /Some-Directory/fish-git-alias/config.fish

# Your other config here
```

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
    - runs `git fetch -p` first
    - finds local branches whose upstream is marked `[gone]`
    - deletes merged branches with `git branch -d`
    - skips unmerged branches unless you pass `--force`
    - never deletes the current branch
- `gst`: show `git status`

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