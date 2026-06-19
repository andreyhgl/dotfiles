# README

This repo contains personal configurations for configs (git, tmux, R), variables and functions.

**Appends** to the existing `.bashrc`.

## Layout

```
dotfiles/
├── bin/
│   └── checksum_verify.sh     # Slurm batch script (md5 verification)
├── shell/
│   ├── bashrc.sh              # entry point, sourced from the system ~/.bashrc
│   ├── exports.sh             # portable environment variables
│   ├── functions.sh           # custom shell functions
│   └── aliases.sh             # shell aliases (git, R, Slurm)
├── dotfiles.local.template    # template for machine-local settings (tracked)
├── install.sh                 # bootstrap: symlinks + appends source block
├── tmux.conf                  # symlinked to ~/.tmux.conf
├── Rprofile                   # symlinked to ~/.Rprofile
├── .gitignore
└── README.md
```

## Install

```sh
folder="dotfiles"

git clone git@github.com:andreyhgl/dotfiles.git "$folder" &&
	cd "$folder" &&
	bash install.sh

# edit the machine-local config
vi ~/.dotfiles.local
source ~/.bashrc
```

`install.sh` is idempotent — safe to run again after a `git pull`.

## Functions

Defined in `shell/functions.sh`.

#### checksum_verify

Submit a checksum verification job (the function wraps `sbatch -A "$ACCOUNT"`):

```sh
checksum_verify path/to/checksums.md5
```

Results appear in the directory the job ran in:
- `_CHECKSUM.OK`      — all checksums matched
- `_CHECKSUM.FAILED`  — one or more failed (contains md5sum's output)

Can also be called directly:

```sh
sbatch -A <account> ~/.local/bin/checksum_verify.sh path/to/checksums.md5
```

### Interactive Slurm session
 
`salloc` is wrapped (in `shell/functions.sh`) to apply sensible defaults and
print a summary before launching the session. Arguments are positional and
optional:
 
```sh
salloc [time] [mem_GB] [cpus]
```
 
| Argument | Default | Example |
|----------|---------|---------|
| `time` | `3:00:00` | `6:00:00` |
| `mem_GB` (G appended automatically) | `20` → `20G` | `40` → `40G` |
| `cpus` | `1` | `4` |
 
```sh
salloc                 # 3:00:00, 20G, 1 cpu
salloc 6:00:00 40 4    # 6h, 40G, 4 cpus
```
 
Requires `ACCOUNT` to be set (in `~/.dotfiles.local`). To bypass the wrapper
and call the real binary directly, use `command salloc ...`.

## Aliases & shortcuts

Defined in `shell/aliases.sh`.

### git

| Command | Expands to | Notes |
|---------|------------|-------|
| `gs`  | `git status --short` | Compact status |
| `ga`  | `git add` | |
| `gd`  | `git diff` | Unstaged changes |
| `gds` | `git diff --staged` | Staged changes |
| `gc`  | `git commit -m "$*"` | Function — no quotes needed: `gc fix the bug`. Quote if using special chars (`> \ '`). |
| `gca`  | `git commit --amend` | Amend, edit message |
| `gcan` | `git commit --amend --no-edit` | Amend, keep message |
| `gsw` | `git switch` | Switch branches |
| `gp`  | `git push` | |
| `gpl` | `git pull` | |
| `gl`  | `git log --graph ...` | Pretty one-line graph log |
| `gt`  | `git for-each-ref ... refs/tags` | Tags, newest first, with date/tagger/subject |
| `gb`  | `git branch -a ...` | All branches, newest commit first, with subject + relative date |

### R

| Command | Expands to | Notes |
|---------|------------|-------|
| `R` | `R --no-save --no-restore` | Stateless interactive R; `Ctrl-D` quits without the save prompt. Interactive only — pass flags explicitly in batch jobs. |

### Slurm

| Command | Expands to | Notes |
|---------|------------|-------|
| `jobinfo`      | `squeue -u $USER` | Your jobs |
| `jobinfo_full` | `squeue -u $USER -o "..." \| column -t \| less -FRXS` | Wide, scrollable job table |

## Configs

#### Tmux

Switch panes using Ctrl+hjkl (vim-style) without prefix

## Machine-local config

Per-cluster values (like `ACCOUNT`) live in `~/.dotfiles.local`, which is
**not** tracked in git. Copy the template and edit it on each machine:

```sh
cp dotfiles.local.template ~/.dotfiles.local
```

## Uninstall

Remove the marked block from `~/.bashrc`:

```sh
# >>> dotfiles >>>
...
# <<< dotfiles <<<
```

or restore the backup `install.sh` made:

```bash
cp ~/.bashrc.backup ~/.bashrc
```

Then remove the symlink: `rm ~/.local/bin/checksum_verify.sh`






<!--

# ZSH manual: https://zsh-manual.netlify.app/

# inspiration 
# dotfiles: https://github.com/bartekspitza/dotfiles/blob/master/install.sh
# bashprompt: https://github.com/mathiasbynens/dotfiles/blob/main/.bash_prompt

# to do

+ add other aliases file

# git logs
+ git log --graph --pretty=format:'%C(auto)%h -%d%Creset %C(cyan)(%cr)%Creset %s'
+ git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
+ git log --graph --pretty=format:"%C(yellow)%h%x09%Creset%C(cyan)%C(bold)%ad%Creset  %C(green)%Creset %s" --date=short
-->
