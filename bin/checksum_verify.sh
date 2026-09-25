#!/bin/bash -l
#SBATCH --time=2:00:00

if [ -z "$SLURM_JOB_ACCOUNT" ]; then
	echo " > Error: no slurm account set!"
	echo " > Usage: sbatch -A <account> $0 $checksum_file" >&2
fi

checksum_file="$1"

if [ -z "$checksum_file" ]; then
	echo " > Usage: sbatch -A <account> $0 path/to/checksums.md5" >&2
	exit 2
fi

if [ ! -f "$checksum_file" ]; then
	echo " > Error: '$checksum_file' not found."
	exit 2
fi

output=$(md5sum -c --quiet "$checksum_file" 2>&1)
status=$?

if [ "$status" -eq 0 ]; then
	echo " ==== All checksum verified successfully ====" > _CHECKSUM.OK
else
	{ echo "Checksum verification FAILED (exit: $status)"
		echo "----"
		echo "$output"
	} > _CHECKSUM.FAILED
fi
