#!/usr/bin/env bash
# Run inside the development container to catch upstream BUNDLE_APP_CONFIG leakage.
set -euo pipefail
repository="$(cd "$(dirname "$0")/.." && pwd)"
workspace="$(mktemp -d)"
trap 'rm -rf "$workspace"' EXIT
inherited_config="${BUNDLE_APP_CONFIG:-/usr/local/bundle}/config"
if [[ -f "$inherited_config" ]]; then
  before="$(sha256sum "$inherited_config")"
else
  before=absent
fi
for name in first second; do
  project="$workspace/$name"
  mkdir -p "$project/scripts"
  cp "$repository/scripts/setup.sh" "$project/scripts/"
  cp "$repository/.ruby-version" "$project/"
  echo '# Deliberately dependency-free isolation fixture.' > "$project/Gemfile"
  (cd "$project" && BUNDLE_APP_CONFIG="$project/.bundle" bundle lock --local)
  bash "$project/scripts/setup.sh"
  ruby -ryaml -e 'config = YAML.load_file(ARGV.fetch(0)); abort "wrong bundle path" unless config.fetch("BUNDLE_PATH") == "vendor/bundle"; abort "not frozen" unless config.fetch("BUNDLE_FROZEN") == "true"' "$project/.bundle/config"
done
if [[ "$before" == absent ]]; then
  [[ ! -f "$inherited_config" ]]
else
  [[ "$(sha256sum "$inherited_config")" == "$before" ]]
fi
[[ "$workspace/first/.bundle/config" != "$workspace/second/.bundle/config" ]]
echo 'Two projects retain independent .bundle/config; inherited config unchanged.'
