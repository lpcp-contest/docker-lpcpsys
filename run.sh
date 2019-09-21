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

# (workaround very slow volume mounts in macOS)
# Note: using 'delegated' mounted volume, for performance
if [ -r runaux.sh ]; then
    cat <<EOF
ERROR: Conflict, runaux.sh already exists
EOF
    exit 1
fi
cat > runaux.sh <<EOF
#!/bin/sh
mkdir -p /data
cp /data0/* /data
cd /data    
$runtimeout /opt/run-$sys.sh \$@
EOF
chmod a+x runaux.sh
docker run --rm $opts -v "$(pwd)":/data0 lpcpsys:latest /data0/runaux.sh "$@"
rm runaux.sh

# docker run --rm $opts -v "$(pwd)":/data:cached lpcpsys:latest $runtimeout /opt/run-$sys.sh "$@"
