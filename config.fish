if status is-interactive
    # Commands to run in interactive sessions can go here

    # Custom Greeting
    function fish_greeting
        # Silencing the greeting cleanly
    end

    # git abbreviations
    # Automatically detects default branch (main/master)
    abbr -a gm 'git switch (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") && git pull'
    abbr -a gw 'git switch'
    abbr -a gwc 'git switch -c'
    abbr -a gwz 'git switch -'
    abbr -a gr 'git fetch && git rebase (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
    abbr -a gf 'git push --force-with-lease'
    abbr -a gz 'git reset --soft HEAD~1'
    abbr -a gb 'git for-each-ref --sort=-committerdate --format="%(refname:short) | %(committerdate:relative) | %(authorname)" refs/heads'
    abbr -a gd 'git branch -d' # Safe delete
    abbr -a gD 'git branch -D' # Force delete
    # Cleans up local branches that are "gone" on remote
    abbr -a gc 'git fetch -p && git for-each-ref --format "%(refname:short) %(upstream:track)" refs/heads | grep -F "[gone]" | cut -d " " -f 1 | xargs -I % git branch -D %'
    abbr -a gst 'git status'
    abbr -a pr 'gh pr create --title (git branch --show-current | sed "s|/|: |g; s|-| |g") --web'
    
    # Utility abbreviations
    abbr -a cf 'code ~/.config/fish/config.fish'
end

# PATH management
# fish_add_path is smarter than set -gx PATH
fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path ~/.local/bin
fish_add_path /Users/hsi/.antigravity/antigravity/bin

# Node Path (Note: Consider using a fish-nvm plugin for better version management)
fish_add_path /Users/hsi/.nvm/versions/node/v20.17.0/bin


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
