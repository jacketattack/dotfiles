# Dotfiles
- My vim, tmux, git, and other assorted settings for development.

# Install
- Files are broken down for my setup based on if I am developing on macOS or linux.
- Run `./install.sh` from a clone of this repo. It detects the OS (`linux/` vs `mac/`) and symlinks each file/`.vim/` folder into `$HOME`, backing up any pre-existing real file to `~/.dotfiles-backup/<timestamp>/` first. Safe to re-run any time (e.g. after `git pull`, or after adding a new file to `linux/`/`mac/`).
- Because the home-dir files are symlinks into this repo, any edits made while using the machine live directly in the repo — just `cd` here, `git status`/`diff` to review, then commit and push.
- Follow the installation instructions from the [solarized dark repo](https://github.com/altercation/solarized). Follow guidance depending on the IDE or terminal application you are using to configure solarized dark .
