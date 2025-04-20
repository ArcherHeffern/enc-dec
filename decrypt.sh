#!/usr/bin/env bash

set -euo pipefail

HELP_MESSAGE=$(cat << 'EOF'
    Usage: decrypt FILE: Decrypt FILE
    Usage: decrypt -h|-help|--help: Display this help message
    Usage: decrypt -s|-select|--select: Select file to decrypt using fzf. Displays only the base filenames
    All files must be of the form <algorithm>:<filename>.enc
EOF
)

if [[ -z ${1:-} ]]; then
	echo "$HELP_MESSAGE" >&2
	exit 1
fi
file="$1"

if [[ "$file" = "-h" || "$file" = "-help" || "$file" = "--help" ]]; then
	echo "$HELP_MESSAGE"
	exit 0
fi

if [[ "$file" = "-s" || "$file" = "-select" || "$file" = "--select" ]]; then
	file=$(fdfind -d1 -Ie enc . | fzf)
	echo "Selected ${file}"
fi 

if [[ ! -e "$file" ]]; then
	echo "FILE does not exist"
	exit 1
fi

echo "$file" | grep -qP ":.*\.enc$" || { echo "File not of form <algorithm>:<filename>.enc" >&2; exit 1; }
algorithm="${file%%:*}"
cat "$file" | openssl "$algorithm" -d 

