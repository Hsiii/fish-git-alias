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

    # Fetch remote changes and rebase the current branch onto origin's default branch.
    abbr -a gr 'git fetch && git rebase origin/(git_default_branch)'

    # Fetch from upstream and rebase the current branch onto upstream.
    abbr -a gru 'git fetch upstream && git rebase upstream'

    # Pull the latest changes into the current branch.
    abbr -a gl 'git pull'

    # Pull the latest changes into the current branch with rebase.
    abbr -a glr 'git pull --rebase'

    # Push the current branch to its configured remote.
    abbr -a gp 'git push'

    # Push the current branch and set origin upstream.
    abbr -a gpu 'git push --set-upstream origin (git branch --show-current)'

    # Force-push safely with lease protection.
    abbr -a gp! 'git push --force-with-lease'

    # Reset the current branch by commit count, defaulting to a soft reset of one commit.
    function gz
        argparse 's/soft' -- $argv
        or return

        set -l count 1
        if test (count $argv) -gt 0
            set count $argv[1]
        end

        if not string match -qr '^[1-9][0-9]*$' -- $count
            echo 'gz: commit count must be a positive integer' >&2
            return 1
        end

        git reset --soft HEAD~$count
    end

    # Hard reset the current branch by commit count, defaulting to one commit.
    function gz!
        set -l count 1
        if test (count $argv) -gt 0
            set count $argv[1]
        end

        if not string match -qr '^[1-9][0-9]*$' -- $count
            echo 'gz!: commit count must be a positive integer' >&2
            return 1
        end

        git reset --hard HEAD~$count
    end

    # List local branches sorted by most recent commit.
    abbr -a gb 'git for-each-ref --sort=-committerdate --format="%(refname:short) | %(committerdate:relative) | %(authorname)" refs/heads'

    # Compare the current branch with the default branch and tracked upstream.
    function gt
        set -l default_branch (git_default_branch)
        if test -z "$default_branch"
            echo 'gt: could not resolve the default branch from origin/HEAD' >&2
            return 1
        end

        set -l default_ref origin/$default_branch
        set -l upstream (git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
        set -l upstream_status $status

        set -l default_counts (git rev-list --left-right --count "$default_ref...HEAD" | string split \t)
        or return

        echo "== current vs $default_ref ($default_counts[1] behind, $default_counts[2] ahead) =="
        if test $default_counts[1] -eq 0 -a $default_counts[2] -eq 0
            echo 'No commit differences.'
        else
            git log --left-right --cherry-pick --oneline --stat "$default_ref...HEAD"
            or return
        end

        echo
        if test $upstream_status -ne 0 -o -z "$upstream"
            echo '== current vs tracked upstream =='
            echo 'gt: no tracked upstream for current branch' >&2
            return 0
        end

        set -l upstream_counts (git rev-list --left-right --count "$upstream...HEAD" | string split \t)
        or return

        echo "== current vs $upstream ($upstream_counts[1] behind, $upstream_counts[2] ahead) =="
        if test $upstream_counts[1] -eq 0 -a $upstream_counts[2] -eq 0
            echo 'No commit differences.'
        else
            git log --left-right --cherry-pick --oneline --stat "$upstream...HEAD"
        end
    end

    # Delete a fully merged local branch.
    abbr -a gd 'git branch -d'

    # Force-delete a local branch.
    abbr -a gd! 'git branch -D'

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
