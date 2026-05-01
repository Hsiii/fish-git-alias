if status is-interactive
    # Disable Fish's default greeting in interactive shells.
    function fish_greeting
        # Silence the greeting.
    end

    # Switch to the remote default branch and pull the latest changes.
    abbr -a gm 'git switch (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") && git pull'

    # Switch to an existing branch.
    abbr -a gw 'git switch'

    # Create and switch to a new branch.
    abbr -a gwc 'git switch -c'

    # Switch back to the previous branch.
    abbr -a gwz 'git switch -'

    # Fetch remote changes and rebase the current branch onto the remote default branch.
    abbr -a gr 'git fetch && git rebase (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'

    # Force-push safely with lease protection.
    abbr -a gf 'git push --force-with-lease'

    # Undo the last commit while keeping the changes staged.
    abbr -a gz 'git reset --soft HEAD~1'

    # List local branches sorted by most recent commit.
    abbr -a gb 'git for-each-ref --sort=-committerdate --format="%(refname:short) | %(committerdate:relative) | %(authorname)" refs/heads'

    # Delete a fully merged local branch.
    abbr -a gd 'git branch -d'

    # Force-delete a local branch.
    abbr -a gD 'git branch -D'

    # Remove local branches whose upstream branches no longer exist on the remote.
    abbr -a gc 'git fetch -p && git for-each-ref --format "%(refname:short) %(upstream:track)" refs/heads | grep -F "[gone]" | cut -d " " -f 1 | xargs -I % git branch -D %'

    # Show repository status.
    abbr -a gst 'git status'

    # Open GitHub PR creation in the browser with a branch-based title.
    abbr -a pr 'gh pr create --title (git branch --show-current | sed "s|/|: |g; s|-| |g") --web'

    # Open the local Fish config in VS Code.
    abbr -a cf 'code ~/.config/fish/config.fish'
end
