# syntax=docker/dockerfile:1
FROM ruby:4.0.10-slim-trixie@sha256:a4b3e62bfe56bd267a3aeacc1b89aea96be919faa0c7d77c6346e2ac14f6c175

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends build-essential git sudo ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME" \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME" \
    && chmod 0440 "/etc/sudoers.d/$USERNAME"

# Optional secret supports managed TLS proxies without persisting their CA.
RUN --mount=type=secret,id=proxy_ca \
    if [ -f /run/secrets/proxy_ca ]; then export SSL_CERT_FILE=/run/secrets/proxy_ca; fi; \
    gem install bundler --version 4.1.0 --no-document \
    && gem install json --version 3.1.0 --no-document

# Replace the vulnerable bundled JSON copy, including its library/native files.
# Keep the patched gem as the only JSON implementation, rather than suppressing a scan.
RUN ruby -rjson -rfileutils -rrbconfig -e 'abort "unexpected JSON" unless JSON::VERSION == "3.1.0"; abort "wrong JSON source" unless $LOADED_FEATURES.any? { |f| f.include?("/json-3.1.0/lib/json.rb") }; [RbConfig::CONFIG.fetch("rubylibdir"), RbConfig::CONFIG.fetch("archdir")].each { |dir| FileUtils.rm_rf(File.join(dir, "json")); FileUtils.rm_f(File.join(dir, "json.rb")) }; Dir.glob(File.join(Gem.default_specifications_dir, "json-*.gemspec")).each { |f| FileUtils.rm_f(f) }' \
    && ruby -rjson -e 'abort "unexpected JSON" unless JSON::VERSION == "3.1.0"; abort "JSON round trip failed" unless JSON.parse(JSON.generate({"日本語" => [1, true, nil]})) == {"日本語" => [1, true, nil]}'

USER $USERNAME
WORKDIR /workspaces/devcontainer-ruby
