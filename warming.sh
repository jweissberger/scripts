#!/bin/bash

set -eo pipefail

file=$1

if [[ -z "$file" ]]; then
    echo "Usage: warming <file>"
fi

cmd <"$file" | grep -o 'progress=.*' | cut -d: -f2-
