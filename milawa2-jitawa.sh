#!/bin/sh

set -e

if [ $# -ne 1 ]
then
    echo "Usage: milawa2-jitawa.sh file.events"
    exit 1
fi

JITAWA=./jitawa

EVENTS=$1

TEMP=`mktemp` || exit 1

# Copy the core.lisp file into temp, dropping comments with sed.
cat core.lisp | sed 's/;.*$//' > $TEMP
echo "(milawa-main '" >> $TEMP
cat $EVENTS >> $TEMP
echo ")" >> $TEMP

# This was `large` originally, but failed with free GitHub Codespaces 2-core/8GB RAM,
# and `medium` is sufficient for the test suite.
$JITAWA medium < $TEMP

rm $TEMP
