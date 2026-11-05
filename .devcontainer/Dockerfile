# syntax=docker/dockerfile:1
FROM ruby:4.0.9-slim-trixie@sha256:9e93d3bcd4541b6826e9bd63f7c5ad027d4689baa1f1cc45b613c5abd7d7e455

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
    gem install bundler --version 4.0.24 --no-document \
    && gem install json --version 3.1.0 --no-document

# Replace the vulnerable bundled JSON copy, including its library/native files.
# Keep the patched gem as the only JSON implementation, rather than suppressing a scan.
RUN ruby -rjson -rfileutils -rrbconfig -e 'abort "unexpected JSON" unless JSON::VERSION == "3.1.0"; abort "wrong JSON source" unless $LOADED_FEATURES.any? { |f| f.include?("/json-3.1.0/lib/json.rb") }; [RbConfig::CONFIG.fetch("rubylibdir"), RbConfig::CONFIG.fetch("archdir")].each { |dir| FileUtils.rm_rf(File.join(dir, "json")); FileUtils.rm_f(File.join(dir, "json.rb")) }; Dir.glob(File.join(Gem.default_specifications_dir, "json-*.gemspec")).each { |f| FileUtils.rm_f(f) }' \
    && ruby -rjson -e 'abort "unexpected JSON" unless JSON::VERSION == "3.1.0"; abort "JSON round trip failed" unless JSON.parse(JSON.generate({"日本語" => [1, true, nil]})) == {"日本語" => [1, true, nil]}'

USER vscode
WORKDIR /workspaces/devcontainer-ruby
