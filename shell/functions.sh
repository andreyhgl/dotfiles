# Custom shell functions.
# Sourced by shell/bashrc.sh

# Submit the checksum verification job to Slurm.
# Usage: checksum_verify <path/to/checksums.md5>
checksum_verify() {
    local file="${1:?Usage: checksum_verify <path/to/checksums.md5>}"
    : "${ACCOUNT:?ACCOUNT not set — edit ~/.dotfiles.local}"
    sbatch -A "$ACCOUNT" "$HOME/.local/bin/checksum_verify.sh" "$file"
}


# Start an interactive salloc session.
# Usage: salloc [time] [mem_GB] [cpus]
#        salloc 6:00:00 40 4 => 6h, 40G, 4 cpus
# defaults to => 3:00:00, 20G, 1 cpu
# 'command salloc' calls the real binary
salloc() {
    local time="${1:-3:00:00}"
    local mem="${2:-20}G"
    local cpus="${3:-1}"
    : "${ACCOUNT:?ACCOUNT not set — edit ~/.dotfiles.local}"
 
    printf '\n'
    printf ' ~~ Starting interactive session ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
    printf ' > \e[35mAccount :\e[0m %s\n' "$ACCOUNT"
    printf ' > \e[35mTime    :\e[0m %s\n' "$time"
    printf ' > \e[35mMemory  :\e[0m %s\n' "$mem"
    printf ' > \e[35mCpus    :\e[0m %s\n' "$cpus"
    printf ' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
 
    command salloc -A "$ACCOUNT" -t "$time" --mem="$mem" -c "$cpus"
}


# List the custom commands this dotfiles setup provides.
dotfiles() {
    cat <<'EOF'

Custom commands (see ~/dotfiles):
---------------------------------
  > dotfiles                       show this list

  Functions:
    checksum_verify <file.md5>     submit md5 verification job to Slurm
    salloc [time] [mem] [cpus]     interactive Slurm session with defaults


  Git aliases:
    gc <message...>                git commit -m (no quotes needed)
    gs ga gd gds                   status / add / diff / diff --staged
    gca gcan                       amend / amend --no-edit
    gsw gp gpl                     switch / push / pull
    gl gt gb                       graph log / tags / branches

  QoL:
    ll lt la                       long listings (size / time / all)
    jobinfo jobinfo_full           Slurm jobs / extra info
    R                              R with --no-save --no-restore

EOF
}