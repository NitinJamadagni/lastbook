#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
PY="$PWD/.venv/bin/python"
if [[ ! -x "$PY" ]]; then
    echo "Missing .venv. Follow the dependency setup in INSTRUCTIONS.md first." >&2
    exit 1
fi

export SURVIVAL_MODEL_BASE="${SURVIVAL_MODEL_BASE:-http://127.0.0.1:11434}"
export SURVIVAL_MODEL="${SURVIVAL_MODEL:-qwen3.8:27b-mlx}"
export LASTBOOK_LOCAL_AI=0

if [[ "${1:-}" == "--server" ]]; then
    shift
    if [[ -z "${LASTBOOK_DATA:-}" ]]; then
        LASTBOOK_DATA="$("$PY" -c 'from app.main import data_folder; print(data_folder(None) or "")')"
        export LASTBOOK_DATA
    fi
    needs_library=1
    for arg in "$@"; do
        case "$arg" in
            --data|--data=*|-h|--help) needs_library=0 ;;
        esac
    done
    if [[ -z "${LASTBOOK_DATA:-}" && "$needs_library" == 1 ]]; then
        echo "No library found. Run bash run_local.sh to install one, or pass --data /path/to/LastbookData." >&2
        exit 1
    fi
    exec "$PY" server.py "$@"
fi

exec "$PY" app/main.py "$@"
