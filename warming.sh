#!/bin/bash

set -eo pipefail

file=$1

if [[ -z "$file" ]]; then
    echo "Usage: warming <file>"
fi

cmd <"$1" | grep -o "progress=.*" | cut -d: -f2- | sed "s/}$//"
