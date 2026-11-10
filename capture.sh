#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"
: "${CAPTURE_URL:?Set CAPTURE_URL to the exact preview URL}"
: "${CAPTURE_DIR:?Set CAPTURE_DIR for screenshots}"
: "${RUNTIME_DIR:?RUNTIME_DIR must point to the worker runtime}"

/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
CAPTURE_STRICT=1 /usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
