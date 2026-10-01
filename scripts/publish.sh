#!/bin/zsh
# Upload a model file as its own immutable release:  scripts/publish.sh <model-id> <file> [version]
set -euo pipefail
id=$1; file=$2; v=${3:-1}
tag="${id%-q*}-v$v"   # e.g. ml-turbo-indicvoices-q8_0 -> ml-turbo-indicvoices-v1
gh release view "$tag" >/dev/null 2>&1 || gh release create "$tag" --title "$id v$v" --notes "See models/$id.md for source, license and attribution."
gh release upload "$tag" "$file" --clobber
echo "https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/releases/download/$tag/$(basename "$file")"
