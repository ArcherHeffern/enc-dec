#!/usr/bin/env bash

set -euo pipefail
ALGORITHM="aes-256-cbc"

if [[ -z ${1:-} ]]; then
	echo "Usage: encrypt FILE" >&2
	exit 1
fi
file="$1"

if [[ "$file" = "-h" || "$file" = "-help" || "$file" = "--help" ]]; then
	echo "Usage: encrypt FILE"
	echo "FILE may not end with .enc"
	exit 0
fi

if [[ ! -e "$file" ]]; then
	echo "FILE does not exist"
	exit 1
fi

echo "$file" | grep -qP "\.enc$" && { echo "FILE may not end with .enc" >&2; exit 1; }
cat "$file" | openssl "$ALGORITHM" > "${ALGORITHM}:${file}.enc"
rm "$file"


