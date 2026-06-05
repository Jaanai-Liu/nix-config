#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")" && cd ../../ && pwd)"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

latestTag=$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/lejianwen/rustdesk-server/releases/latest | jq -r ".tag_name")
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; rustdesk-server-pro.version" | tr -d '"')

if [ "$currentVersion" = "$latestTag" ]; then
  echo "rustdesk-server-pro is up-to-date: $currentVersion"
  exit 0
fi

echo "Updating rustdesk-server-pro from $currentVersion to $latestTag"

for arch in x86_64-linux aarch64-linux; do
  case $arch in
    x86_64-linux) binArch="amd64" ;;
    aarch64-linux) binArch="arm64v8" ;;
  esac

  hash=$(nix-prefetch-url "https://github.com/lejianwen/rustdesk-server/releases/download/v$latestTag/rustdesk-server-linux-$binArch.zip" 2>/dev/null || echo "")
  if [ -n "$hash" ]; then
    (cd "${BASEDIR}" && update-source-version rustdesk-server-pro "$latestTag" "$hash" --system="$arch" --ignore-same-version)
  fi
done
