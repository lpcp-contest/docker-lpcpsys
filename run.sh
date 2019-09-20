#!/bin/sh

# Physical directory where the script is located
_base=$(e=$0;while test -L "$e";do d=$(dirname "$e");e=$(readlink "$e");\
        cd "$d";done;cd "$(dirname "$e")";pwd -P)

# Usage:
#   run.sh SYSTEM ARGS
# Environment:
#   TIMEOUT: use timeout

sys=$1
shift

opts=
if [ -t 0 ]; then # input is a tty
    opts="$opts -ti"
fi

# TODO: make timeout configurable
if [ x"$TIMEOUT" = x ]; then # No timeout
    runtimeout=""
else
    runtimeout="timeout ${TIMEOUT}"
fi

# Note: using 'delegated' mounted volume, for performance
docker run --rm $opts -v "$(pwd)":/data:delegated lpcpsys:latest $runtimeout /opt/run-$sys.sh "$@"
