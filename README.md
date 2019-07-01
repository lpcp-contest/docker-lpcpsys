# Docker for LP/CP Contest

This docker provides a dockerized version of the systems used for the
LP/CP contest.

Build this image with:
```
docker build -t lpcpsys:latest .
```

(For debugging) open a bash terminal with:
```
docker run --rm -ti lpcpsys:latest 
```

# Usage

Execute with `run.sh SYSNAME`, where SYSNAME is one of:

 - clingo
 - eclipseclp
 - idp
 - minizinc
 - picat
 - xsb
 - ciao
 - gprolog
 - swipl

# Examples

```
sudo ./run.sh ciao -u /data/blocked_ciao.pl -e "main,halt"
sudo ./run.sh swipl -g "main,halt" /data/blocked_swi.pl
```
