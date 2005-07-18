#!/bin/sh
declare -r SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)
[[ -x "$SCRIPT_DIR/$(basename $0)" ]] || echo Script directory not found >&2
declare -r SCRIPT_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
declare -r SCRIPT_VAR="$SCRIPT_ROOT/var/lib/quill"
[[ -d "$SCRIPT_VAR" ]] || echo Script modules directory not found >&2
declare -r SCRIPT_TMP="${TMP:-$SCRIPT_DIR}"
[[ -d "$SCRIPT_TMP" ]] || echo Script temporary directory not found >&2

declare -r MKSPELL="$SCRIPT_TMP/MKSPELL.$$.sh"

PARAM_PERSIST='--stringparam persist true'
PARAM_DEBUG='--stringparam debug true'

## TODO process input parameters and modify default settings

PARAM_PROJECT="--stringparam project $1"

xsltproc $PARAM_PERSIST $PARAM_DEBUG $PARAM_PROJECT \
  "$SCRIPT_VAR/fm2spell.xsl" \
  "$SCRIPT_VAR/dummy.xml" \
  > "$MKSPELL" &&
echo Running $MKSPELL... >&2 &&
source "$MKSPELL" &&
rm -f "$MKSPELL"
