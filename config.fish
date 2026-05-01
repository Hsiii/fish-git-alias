if status is-interactive
    # Disable Fish's default greeting in interactive shells.
    function fish_greeting
        # Silence the greeting.
    end

    # Resolve the remote default branch name from origin/HEAD.
    function git_default_branch
        git symbolic-ref refs/remotes/origin/HEAD | string replace 'refs/remotes/origin/' ''
    end

    # Switch to the remote default branch and pull the latest changes.
    abbr -a gm 'git switch (git_default_branch) && git pull'

    # Switch to an existing branch.
    abbr -a gw 'git switch'

    # Create and switch to a new branch.
    abbr -a gwc 'git switch -c'

    # Switch back to the previous branch.
    abbr -a gwz 'git switch -'

    # Fetch remote changes and rebase the current branch onto the remote default branch.
    abbr -a gr 'git fetch && git rebase (git_default_branch)'

    # Force-push safely with lease protection.
    abbr -a gf 'git push --force-with-lease'

    # Reset the current branch by commit count, defaulting to a soft reset of one commit.
    function gz
        argparse 'h/hard' 's/soft' -- $argv
        or return

        if set -q _flag_hard; and set -q _flag_soft
            echo 'gz: choose either --hard or --soft' >&2
            return 1
        end

        set -l reset_mode soft
        if set -q _flag_hard
            set reset_mode hard
        end

        set -l count 1
        if test (count $argv) -gt 0
            set count $argv[1]
        end

        if not string match -qr '^[1-9][0-9]*$' -- $count
            echo 'gz: commit count must be a positive integer' >&2
            return 1
        end

        git reset --$reset_mode HEAD~$count
    end

    # List local branches sorted by most recent commit.
    abbr -a gb 'git for-each-ref --sort=-committerdate --format="%(refname:short) | %(committerdate:relative) | %(authorname)" refs/heads'

    # Delete a fully merged local branch.
    abbr -a gd 'git branch -d'

    # Force-delete a local branch.
    abbr -a gD 'git branch -D'

    # Remove local branches whose upstream is gone, deleting unmerged branches only with --force.
    function gc
        argparse 'f/force' -- $argv
        or return

        git fetch -p
        or return

        set -l default_branch (git_default_branch)
        if test -z "$default_branch"
            echo 'gc: could not resolve the default branch from origin/HEAD' >&2
            return 1
        end

        set -l current_branch (git branch --show-current)
        set -l gone_branches (
            git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads |
            string match -r '.+ \[gone\]$' |
            string replace -r ' \[gone\]$' ''
        )

        if test (count $gone_branches) -eq 0
            echo 'gc: no local branches with gone upstreams'
            return 0
        end

        for branch in $gone_branches
            if test "$branch" = "$current_branch"
                echo "gc: skipping current branch $branch"
                continue
            end

            if git merge-base --is-ancestor $branch $default_branch
                git branch -d $branch
                continue
            end

            if set -q _flag_force
                git branch -D $branch
            else
                echo "gc: skipping unmerged gone branch $branch (use --force to delete)" >&2
            end
        end
    end

    # Cherry-pick one or more commits onto the current branch.
    abbr -a gcp 'git cherry-pick'

    # Show repository status.
    abbr -a gst 'git status'

    # Open GitHub PR creation in the browser with a branch-based title.
    abbr -a pr 'gh pr create --title (git branch --show-current | sed "s|/|: |g; s|-| |g") --web'

    # Open the local Fish config in VS Code.
    abbr -a cf 'code ~/.config/fish/config.fish'
end
