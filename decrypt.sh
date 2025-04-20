#!/usr/bin/env bash

set -euo pipefail

if [[ -z ${1:-} ]]; then
	echo "Usage: decrypt FILE" >&2
	exit 1
fi
file="$1"

if [[ "$file" = "-h" || "$file" = "-help" || "$file" = "--help" ]]; then
	echo "Usage: decrypt FILE"
	echo "All files must be of the form <algorithm>:<filename>.enc"
	exit 0
fi

if [[ ! -e "$file" ]]; then
	echo "FILE does not exist"
	exit 1
fi

echo "$file" | grep -qP ":.*\.enc$" || { echo "File not of form <algorithm>:<filename>.enc" >&2; exit 1; }
algorithm="${file%%:*}"
cat "$file" | openssl "$algorithm" -d 

