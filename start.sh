#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"
PORT="${PORT:-3000}"
BUILD_DIR="$PROJECT_DIR/dist"

# This is a self-contained static HTML project; there is no dependency manifest.
/usr/bin/time -p test -f "$PROJECT_DIR/Stick-Fight.html"
/usr/bin/time -p mkdir -p "$BUILD_DIR"
/usr/bin/time -p cp "$PROJECT_DIR/Stick-Fight.html" "$BUILD_DIR/index.html"
/usr/bin/time -p python3 -c 'import struct,sys; p=sys.argv[1]; dib=struct.pack("<IIIHHIIIIII",40,1,2,1,32,0,4,0,0,0,0)+bytes((80,170,255,255))+bytes(4); open(p,"wb").write(struct.pack("<HHH",0,1,1)+struct.pack("<BBBBHHI",1,1,0,0,1,32,len(dib))+struct.pack("<I",22)+dib)' "$BUILD_DIR/favicon.ico"

# Worker metadata and deployment evidence stay outside the source/build tree.
: "${OPENCODE_WEB_DIR:?OPENCODE_WEB_DIR must be set}"
/usr/bin/time -p mkdir -p "$OPENCODE_WEB_DIR"
PROJECT_DIR="$PROJECT_DIR" BUILD_DIR="$BUILD_DIR" OPENCODE_WEB_DIR="$OPENCODE_WEB_DIR" /usr/bin/time -p python3 -c 'import json,os; json.dump({"project":os.path.realpath(os.environ["PROJECT_DIR"]),"directory":os.path.realpath(os.environ["BUILD_DIR"])},open(os.path.join(os.environ["OPENCODE_WEB_DIR"],"deployment-output.json"),"w"))'

export PORT
/usr/bin/time -p python3 -m http.server "$PORT" --bind 0.0.0.0 --directory "$BUILD_DIR"
