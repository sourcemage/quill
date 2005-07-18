#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)
[[ -x "$SCRIPT_DIR/$(basename $0)" ]] || echo Script directory not found &>2
SCRIPT_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
SCRIPT_MOD="$SCRIPT_ROOT/var/lib/quill/modules"
[[ -d "$SCRIPT_MOD" ]] || echo Script modules directory not found &>2
SCRIPT_TMP="$SCRIPT_ROOT/tmp"
[[ -d "$SCRIPT_TMP" ]] || echo Script temporary directory not found &>2

MKDETAILS="$SCRIPT_TMP/mkdetails.$$.sh"

xsltproc --stringparam project "$1" \
  "$SCRIPT_MOD/fm2spell.xsl" \
  "$SCRIPT_MOD/dummy.xml" \
  > "$MKDETAILS" &&
source "$MKDETAILS" &&
rm -f "$MKDETAILS"
