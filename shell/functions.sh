# Custom shell functions.
# Sourced by shell/bashrc.sh

# Checksum for sequencing files
# Submit to SLURM if sbatch is installed and $ACCOUNT is set,
# otherwise run locally with bash. Works when sourced from bash or zsh.
checksum_verify() {
    local usage="
 Usage: checksum_verify [-h] <folder | checksums.md5 [more.md5 ...]>

 Verify files against MD5 checksum lists. Given a folder, checks every
 .md5 file in it. Writes _CHECKSUM.OK or _CHECKSUM.FAILED to the
 directory the command ran from.

 Submits the job via sbatch when ACCOUNT is set (see ~/.dotfiles.local),
 otherwise runs locally with bash.

 Examples:
   checksum_verify /path/to/delivery                # every .md5 in folder
   checksum_verify P36012_1021.md5 P36012_1022.md5  # specific .md5 files

 Options:
   -h, --help       Show this help and exit"

    case "${1:-}" in
        -h|--help) echo "$usage"; return 0 ;;
        "") echo "$usage" >&2; return 1 ;;
    esac

    local dir="." files=""

    if [[ $# -eq 1 && -d "$1" ]]; then
        # Folder mode: the job cd's there and finds the .md5 files itself
        dir="$1"
        if [[ -z $(find "$dir" -maxdepth 1 -type f -name '*.md5' | head -n 1) ]]
        then
            echo " > Error: no .md5 files in '$dir'." >&2
            return 2
        fi
    else
        # File mode: one path per line, split back into an array in the job
        local f
        for f in "$@"; do
            if [[ ! -f "$f" ]]; then
                echo " > Error: '$f' is not a file." >&2
                echo " > Pass a single folder, or one or more .md5 files." >&2
                return 2
            fi
        done
        files=$(printf '%s\n' "$@")
    fi

    # Job body: always run by bash, reads $CHECKSUM_DIR and $CHECKSUM_FILES
    local job
    job=$(cat <<'EOF'
#!/bin/bash -l
out_dir="$PWD"
cd "$CHECKSUM_DIR" || exit 2

if [[ -n "$CHECKSUM_FILES" ]]; then
    mapfile -t files <<< "$CHECKSUM_FILES"
else
    shopt -s nullglob
    files=(*.md5)
fi

echo " > Checking ${#files[@]} checksum file(s) in $PWD"

{
    output=$(
        md5sum -c "${files[@]}" 2>&1 | tee /dev/fd/3
        exit "${PIPESTATUS[0]}"
    )
    rc=$?
} 3>&1

if (( rc == 0 )); then
    echo " ==== All checksum verified successfully ====" \
    > "$out_dir/_CHECKSUM.OK"
else
    {
        echo "Checksum verification FAILED (exit: $rc)"
        echo "----"
        grep -v ': OK$' <<< "$output"
    } > "$out_dir/_CHECKSUM.FAILED"
fi

exit "$rc"
EOF
    )

    if [[ -n "${ACCOUNT:-}" ]] && command -v sbatch >/dev/null 2>&1; then
        CHECKSUM_DIR="$dir" CHECKSUM_FILES="$files" \
            sbatch -A "$ACCOUNT" -t 2:00:00 -J checksum_verify \
            --export=ALL <<< "$job"
    else
        echo " > ACCOUNT not set or sbatch not found; running locally" >&2
        CHECKSUM_DIR="$dir" CHECKSUM_FILES="$files" bash <<< "$job"
    fi
}


# Start an interactive salloc session.
# Usage: salloc [time] [mem_GB] [cpus]
#        salloc  6      40       4
# defaults to => 3:00:00, 60G, 1 cpu
# 'command salloc' calls the real binary
salloc() {
    local time="${1:-3}"
    local mem="${2:-60}"
    local cpus="${3:-1}"
    : "${ACCOUNT:?ACCOUNT not set — edit ~/.dotfiles.local}"

    # Plain number = hours (e.g. 3 -> 3:00:00, 1.5 -> 1:30:00)
    if [[ $time =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        time=$(awk -v h="$time" 'BEGIN {
            m = int(h * 60 + 0.5)
            printf "%d:%02d:00", int(m / 60), m % 60
        }')
    fi

    # Plain number = GB; allow explicit units like 500M or 1T
    [[ $mem =~ ^[0-9]+$ ]] && mem="${mem}G"

    local fmt=' \e[35m%7s\e[0m : %s\n'

    printf '\n ~~ Starting interactive session ~~~~~~~~~~~~~\n'
    printf "$fmt" "Account" "$ACCOUNT"
    printf "$fmt" "Time"    "$time"
    printf "$fmt" "Memory"  "$mem"
    printf "$fmt" "Cpus"    "$cpus"
    printf ' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n'

    command salloc -A "$ACCOUNT" -t "$time" --mem="$mem" -c "$cpus"
}

#gpl() { git ${1:+-C "$1"} pull; }

gpl() {
    if [ -n "$1" ]; then
        git -C "$1" pull
    else
        git pull
    fi
}


#---- Nextflow QoL ------------------------------------------------------------

# Make sure nextflow is available, loads module if required.
# reads NEXTFLOW_MODULE from ~/.dotfiles.local
_nf_ensure() {
    command -v nextflow >/dev/null 2>&1 && return 0
    if ! command -v module >/dev/null 2>&1; then
        echo "nextflow not found and no module system" >&2
        return 1
    fi
    # eval lets NEXTFLOW_MODULE hold several modules in bash and zsh
    eval "module load ${NEXTFLOW_MODULE:-nextflow}"
}

# Print "(Today)" or "(N days ago)" for a YYYY-MM-DD date.
# Counts calendar days, so last night's run is "1 day ago".
# Prints nothing if the date can't be parsed.
_nf_ago() {
    local d="$1" today then now days
    today=$(date +%F)
    # GNU date first, then BSD/macOS date
    then=$(date -u -d "$d" +%s 2>/dev/null ||
        date -u -j -f %F "$d" +%s 2>/dev/null) || return 0
    now=$(date -u -d "$today" +%s 2>/dev/null ||
        date -u -j -f %F "$today" +%s 2>/dev/null) || return 0
    days=$(( (now - then) / 86400 ))
    case "$days" in
        0) echo "(Today)" ;;
        1) echo "(1 day ago)" ;;
        *) echo "($days days ago)" ;;
    esac
}

# Show the latest Nextflow run log
# duration = from submit to finish
# realtime = run time
# $ nflog            (last run)
# $ nflog [run_name] (specific run)
nflog() {
    _nf_ensure || return 1
    nextflow log "${1:-last}" -f status,hash,duration,realtime,name | less -FRXS
}

# Delete the latest work files. Asks for confirmation!
# $ nfclean            (last run)
# $ nfclean [run_name] (specific run)
nfclean() {
    _nf_ensure || return 1
    local run="${1:-last}"

    # Dry run only to make sure clean can resolve the run.
    nextflow clean "$run" -n >/dev/null || return 1

    local row
    if [ "$run" = "last" ]; then
        row=$(nextflow log 2>/dev/null | tail -n 1)
    else
        row=$(nextflow log 2>/dev/null |
            awk -F'\t' -v r="$run" '{ gsub(/^ +| +$/, "", $3) } $3 == r')
    fi
    if [ -z "$row" ]; then
        echo "No run found: $run" >&2
        return 1
    fi

    local ago
    ago=$(_nf_ago "$(printf '%s\n' "$row" |
        awk -F'\t' '{ split($1, a, " "); print a[1] }')")

    echo "--------------------------------"
    echo "$row" | awk -F'\t' -v ago="$ago" '{
        for (i = 1; i <= 4; i++) gsub(/^ +| +$/, "", $i)
        fmt = " %8s : %s\n"
        started = $1
        if (ago != "") started = "\033[35m" ago "\033[0m " started
        printf fmt, "Run", $3
        printf fmt, "Started", started
        printf fmt, "Duration", $2
        printf fmt, "Status", $4
        print ""
    }'

    local changed
    changed=$(
        nextflow log "$run" -f hash,name,status,workdir,realtime 2>/dev/null |
            sort -t$'\t' -k2,2 -k1,1 |
            while IFS=$'\t' read -r hash name status workdir realtime; do
                [ "$status" = "CACHED" ] && continue
                local size=$(du -sh "$workdir" 2>/dev/null | cut -f1)
                printf ' > %9s  %8s  %6s  %s\n' \
                    "${hash:0:9}" "${realtime}" "${size:--}" "$name"
            done
    )

    echo " Work directories to delete (changed tasks only):"
    if [ -n "$changed" ]; then
        echo "$changed"
    else
        echo " (none, all tasks were cached)"
    fi
    echo

    printf ' Delete these files? [y/N] '
    read -r reply
    case "$reply" in
        [yY]*) nextflow clean "$run" -f ;;
        *) echo "Aborted." ;;
    esac
}

# List the custom commands this dotfiles setup provides.
dotfiles_help() {
    cat <<'EOF'

Custom commands (see ~/dotfiles):
---------------------------------
    ,dotfiles                   show this list

    Functions:
    ---------
    checksum_verify <file.md5>  submit md5 verification job to Slurm
    salloc [time] [mem] [cpus]  interactive Slurm session with defaults
            
    Nextflow functions:
    -------------------
    nflog [run_name]            Nextflow run log (defaults latest run)
    nfclean [run_name]          detele run work files (defaults latest run)
    
    Git aliases:
    ------------
    gc <message...>             git commit -m (no quotes needed)
    gs ga gd gds                status / add / diff / diff --staged
    gca gcan                    amend / amend --no-edit
    gsw gp                      switch / push
    gpl [dir]                   pull (add 'git -C' if directory given)
    gl gt gb                    graph log / tags / branches

    QoL:
    ----
    ll lt la                    long listings (size / time / all)
    jobinfo jobinfo_full        Slurm jobs / extra info
    R                           R with --no-save --no-restore

EOF
}

alias ',dotfiles'='dotfiles_help'
