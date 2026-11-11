#!/usr/bin/env bash
# Publish an official WordCraft web release zip to the gh-pages branch.
# Usage: ./scripts/publish-gh-pages.sh <version>
# Example: ./scripts/publish-gh-pages.sh 0.17.0
set -euo pipefail

VER="${1:-}"
if [ -z "${VER}" ]; then
  echo "usage: $0 <version>   # e.g. 0.17.0  (no leading v)" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ORIGIN="$(git -C "${REPO_ROOT}" remote get-url origin)"
BASE="https://github.com/storytold/wordcraft/releases/download/v${VER}"
ZIP="wordcraft-web-${VER}.zip"

WORKDIR="$(mktemp -d)"
cleanup() { rm -rf "${WORKDIR}"; }
trap cleanup EXIT

echo "Downloading ${ZIP} and SHA256SUMS.txt"
curl -fsSL -o "${WORKDIR}/SHA256SUMS.txt" "${BASE}/SHA256SUMS.txt"
curl -fsSL -o "${WORKDIR}/${ZIP}" "${BASE}/${ZIP}"
(
  cd "${WORKDIR}"
  grep -F " ${ZIP}" SHA256SUMS.txt | sha256sum -c -
  unzip -q "${ZIP}" -d unpack
)
SRC="$(find "${WORKDIR}/unpack" -maxdepth 2 -name index.html -printf '%h\n' | head -n1)"
if [ -z "${SRC}" ]; then
  echo "index.html not found in ${ZIP}" >&2
  exit 1
fi

SITE="${WORKDIR}/site"
mkdir -p "${SITE}"
cp -a "${SRC}/." "${SITE}/"
touch "${SITE}/.nojekyll"

git -C "${SITE}" init -b gh-pages
git -C "${SITE}" config user.name "antojitos-ahumados"
git -C "${SITE}" config user.email "antojitos-ahumados@users.noreply.github.com"
git -C "${SITE}" add -A
git -C "${SITE}" commit -m "Publish official WordCraft web ${VER}"
git -C "${SITE}" remote add origin "${ORIGIN}"
# Prefer GH_TOKEN when set. Use git username/password auth, not a bearer header.
if [ -n "${GH_TOKEN:-}" ]; then
  ASKPASS="$(mktemp)"
  cat > "${ASKPASS}" << 'SCRIPT'
#!/bin/bash
case "${1:-}" in
  *Username*) echo "x-access-token" ;;
  *) echo "${GH_TOKEN}" ;;
esac
SCRIPT
  chmod 700 "${ASKPASS}"
  GIT_ASKPASS="${ASKPASS}" GIT_TERMINAL_PROMPT=0 git -C "${SITE}" push --force origin gh-pages
  rm -f "${ASKPASS}"
else
  git -C "${SITE}" push --force origin gh-pages
fi
echo "Published WordCraft web ${VER} to gh-pages"
