#!/usr/bin/env bash
# Installs the rom CLI: a venv with Textual + wrappers in ~/bin.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/bin"
DEST="${PREFIX:-$HOME/bin}"
VENV="${ROM_VENV:-$HOME/.venvs/rom}"
PY="${PYTHON:-python3}"

command -v "$PY" >/dev/null || { echo "python3 not found"; exit 1; }
mkdir -p "$DEST" "$(dirname "$VENV")"

if [ ! -x "$VENV/bin/python" ]; then
  echo "creating venv in ${VENV}"
  "$PY" -m venv "$VENV"
fi

echo "installing textual"
"$VENV/bin/pip" install -q --upgrade pip >/dev/null 2>&1 || true
"$VENV/bin/pip" install -q textual

write_wrapper() {
  local name="$1" target="$2"
  cat > "$DEST/$name" <<EOF
#!/bin/zsh
exec "$VENV/bin/python" "$target" "\$@"
EOF
  chmod 755 "$DEST/$name"
}

write_wrapper rom "$SRC/rom"

if [ -f "$SRC/rom-remote" ]; then
  install -m 755 "$SRC/rom-remote" "$DEST/rom-remote"
fi

echo "installed: $DEST/rom (venv: $VENV)"
case ":$PATH:" in
  *":$DEST:"*) ;;
  *) echo "warning: add $DEST to your PATH (e.g. set -Ux fish_user_paths $DEST)";;
esac
echo "test: rom -l    |    rom --index"
