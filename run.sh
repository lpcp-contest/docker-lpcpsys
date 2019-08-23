#!/bin/sh

# Physical directory where the script is located
_base=$(e=$0;while test -L "$e";do d=$(dirname "$e");e=$(readlink "$e");\
        cd "$d";done;cd "$(dirname "$e")";pwd -P)

sys=$1
shift

opts=
if [ -t 0 ]; then # input is a tty
    opts="$opts -ti"
fi

# TODO: share current dir so that we can pass files as args
#docker run --rm $opts -v "$(pwd)"/../2016_samples:/data lpcpsys:latest /opt/run-$sys.sh "$@"
docker run --rm $opts -v "$(pwd)":/data lpcpsys:latest /opt/run-$sys.sh "$@"

