#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
expected="$(cat .ruby-version)"
actual="$(ruby -e 'print RUBY_VERSION')"
if [[ "$actual" != "$expected" ]]; then
  echo "Ruby $expected required; found $actual. Rebuild the Dev Container." >&2
  exit 1
fi
# The upstream image sets BUNDLE_APP_CONFIG globally. Scope all writes to this repo.
export BUNDLE_APP_CONFIG="$PWD/.bundle"
bundle config set --local path vendor/bundle
bundle config set --local frozen true
bundle install
