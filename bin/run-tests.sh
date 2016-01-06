#!/usr/bin/env bash

RUNNER=tools/packaging/test262.py
LOCAL_V8=/Users/leobalter/dev/v8/out/native/d8

function help() {
  cat <<HELP
Usage: run-tests.sh [RUNTIME]
Execute the "new" Test262 tests (any files in the current branch but not in
master). In the absense of a specific RUNTIME, the locally-built version of V8
will be used.
HELP
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then help; exit; fi

RUNTIME=$1
if [ -z "$RUNTIME" ]; then
  RUNTIME=$LOCAL_V8
fi

while IFS= read -r -d '' NEW_TEST; do
  $RUNNER --command "$RUNTIME" $NEW_TEST
done < <(git diff master -z --name-only --relative=test)
