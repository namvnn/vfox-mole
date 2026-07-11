#!/usr/bin/env bash

set -euo pipefail

tool='mole'

mise plugin link --force "${tool}" .
mise cache clear
mise install "${tool}"
mise exec "${tool}" -- "${tool}" --version

home="${XDG_DATA_HOME:-${HOME}}"
mise_data_dir="${MISE_DATA_DIR:-${home}/.local/share/mise}"
mise uninstall "${tool}"
rm -rf "${mise_data_dir}/plugins/${tool}" 

echo "✓ Tests passed"
