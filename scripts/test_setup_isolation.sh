#!/usr/bin/env bash
# Run inside the development container to catch upstream BUNDLE_APP_CONFIG leakage.
# The official ruby image sets BUNDLE_APP_CONFIG=/usr/local/bundle for every process;
# setup.sh must write its settings to the project's own .bundle/config instead.
set -euo pipefail
repository="$(cd "$(dirname "$0")/.." && pwd)"
workspace="$(mktemp -d)"
trap 'rm -rf "$workspace"' EXIT

upstream_config=/usr/local/bundle/config
inherited_config="${BUNDLE_APP_CONFIG:-/usr/local/bundle}/config"
fingerprint() {
  if [[ -f "$1" ]]; then sha256sum "$1"; else echo "absent $1"; fi
}
before_upstream="$(fingerprint "$upstream_config")"
before_inherited="$(fingerprint "$inherited_config")"

# first: the upstream image default. second: whatever this shell inherited
# (the Dev Container sets it to the repository's .bundle).
for name in first second; do
  project="$workspace/$name"
  mkdir -p "$project/scripts"
  cp "$repository/scripts/setup.sh" "$project/scripts/"
  cp "$repository/.ruby-version" "$project/"
  echo '# Deliberately dependency-free isolation fixture.' > "$project/Gemfile"
  (cd "$project" && BUNDLE_APP_CONFIG="$project/.bundle" bundle lock --local)
  if [[ "$name" == first ]]; then
    BUNDLE_APP_CONFIG=/usr/local/bundle bash "$project/scripts/setup.sh"
  else
    bash "$project/scripts/setup.sh"
  fi
  ruby -ryaml -e '
    config = YAML.load_file(ARGV.fetch(0))
    abort "wrong bundle path" unless config.fetch("BUNDLE_PATH") == "vendor/bundle"
    abort "not frozen" unless config.fetch("BUNDLE_FROZEN") == "true"
  ' "$project/.bundle/config"
done

if [[ "$(fingerprint "$upstream_config")" != "$before_upstream" ]]; then
  echo "setup.sh modified the upstream $upstream_config" >&2
  exit 1
fi
if [[ "$(fingerprint "$inherited_config")" != "$before_inherited" ]]; then
  echo "setup.sh modified the inherited $inherited_config" >&2
  exit 1
fi
echo "Each project wrote its own .bundle/config; $upstream_config and $inherited_config unchanged."
