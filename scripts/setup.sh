#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
expected="$(cat .ruby-version)"
actual="$(ruby -e 'print RUBY_VERSION')"
if [[ "$actual" != "$expected" ]]; then
  echo "Ruby $expected required; found $actual. Rebuild the Dev Container." >&2
  exit 1
fi
bundle config set --local path vendor/bundle
bundle config set --local frozen true
bundle install
