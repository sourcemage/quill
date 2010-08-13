#!/bin/bash

#
# This script will generate bash documentation (for as far as it has been made
# available in the code) from Quill.
#
BIN=/usr/bin
DOCDIR=/usr/share/doc/quill/htmldocs
BASHDOC=$BIN/bashdoc.sh
FLOW=$BIN/flow.sh
SRC2HTML=$BIN/src2html.sh
PROJECT=Quill

QUIET=${QUIET:--q -q}

SCRIPTS="/var/lib/quill/modules/lib* /var/lib/quill/modules/site_handlers/* \
/usr/bin/quill"
#exclude non-sorcery files, like backups~ or numbered versions
for FILE in $SCRIPTS
do
        if grep -q "[0-9]" <<< $FILE; then
                if grep -Eq "(libgcc2|api[12])" <<< $FILE; then
                        SCRIPTS2="$SCRIPTS2 $FILE"
                fi
        elif grep -q '~' <<< $FILE; then
                true
        else
                SCRIPTS2="$SCRIPTS2 $FILE"
        fi
done
SCRIPTS="$SCRIPTS2"

# make the bashdoc dir
if [ -d $DOCDIR ] ; then
        rm -rf $DOCDIR
        mkdir -p $DOCDIR
else
        mkdir -p $DOCDIR
fi

# generate docs for libs
if [  -x  "$BASHDOC"  ] ; then
        $BASHDOC ${QUIET} -p $PROJECT -o $DOCDIR $SCRIPTS
else
        echo "The bashdoc tools are not installed, please cast bashdoc!"
fi

${SRC2HTML} --funcs $DOCDIR $SCRIPTS
if which dot >/dev/null 2>&1 ; then
        ${FLOW} --funcs $DOCDIR --exclude debug --exclude query \
                --exclude message --exclude error_msg $SCRIPTS
else
        echo "No graphviz found, not generating images."
fi

# end
