#!/bin/sh

# ## Systems (alphabetically ordered)
# 
#  - Ciao: https://ciao-lang.org/
#  - Clingo: https://potassco.org/clingo/
#  - Eclipse Prolog: https://eclipseclp.org/download.html
#  - IDP: https://dtai.cs.kuleuven.be/software/idp/try
#  - MiniZinc: https://www.minizinc.org/
#  - Picat: http://picat-lang.org/
#  - SICSTUS: https://sicstus.sics.se/ (non-free)
#  - SWI: http://www.swi-prolog.org/
#  - XSB: http://xsb.sourceforge.net/
# 
# ## Notes
# 
# - IDP has a dockerized version: https://dtai.cs.kuleuven.be/krr/files/releases/idp/README-DOCKER.md

apt-get -y update
apt-get -y upgrade

# Some common dependencies
apt-get install -y git make tar curl gcc

# TODO: do "apt-get clean"

# ===========================================================================
# Auxiliary

gen_runscript() { # sys bin pathdir
    cat > /opt/run-$1.sh <<EOF
#!/bin/sh
export PATH=\$PATH:$3
$2 "\$@"
EOF
    chmod a+x /opt/run-$1.sh
}

gen_runscript1() { # sys bin
    cat > /opt/run-$1.sh <<EOF
#!/bin/sh
$2 "\$@"
EOF
    chmod a+x /opt/run-$1.sh
}

# ===========================================================================
# Get, build, and install each system

# ---------------------------------------------------------------------------
# Clingo: https://potassco.org/clingo/

install_clingo() {
    # TODO: from bin? "conda install -c potassco clingo"

    CLINGO_VER=master

    apt-get -y install build-essential git cmake bison gcc re2c

    mkdir -p /opt/clingo
    cd /opt/clingo \
      && git init \
      && git remote add origin https://github.com/potassco/clingo.git \
      && git fetch origin ${CLINGO_VER} \
      && git pull origin ${CLINGO_VER} \
      && git submodule update --init --recursive

    cd /opt/clingo
    cmake -H/opt/clingo -B/opt/clingo -DCMAKE_BUILD_TYPE=release \
      && cmake --build /opt/clingo

    gen_runscript clingo clingo /opt/clingo/bin
}

# ---------------------------------------------------------------------------
# Eclipse Prolog: https://eclipseclp.org/download.html

install_eclipseclp() {
    mkdir -p /opt/eclipseclp
    cd /opt/eclipseclp
    curl -O https://eclipseclp.org/Distribution/Builds/7.0_45/x86_64_linux/eclipse_basic.tgz
    curl -O https://eclipseclp.org/Distribution/Builds/7.0_45/x86_64_linux/eclipse_rt.tgz
    tar -xzf eclipse_basic.tgz
    tar -xzf eclipse_rt.tgz
    ./RUNME
    gen_runscript eclipseclp eclipse /opt/eclipseclp/bin/x86_64_linux
}

# ---------------------------------------------------------------------------
# IDP: https://dtai.cs.kuleuven.be/software/idp/try

install_idp() {
    mkdir -p /opt/idp
    cd /opt/idp
    curl -O https://dtai.cs.kuleuven.be/krr/files/releases/idp/idp-linux-latest.tar.gz
    tar -xzf idp-linux-latest.tar.gz
    gen_runscript idp idp /opt/idp/idp3-3.7.1-Linux/usr/local/bin
}

# ---------------------------------------------------------------------------
# MiniZinc: https://www.minizinc.org/

install_minizinc() {
    mkdir -p /opt/minizinc
    cd /opt/minizinc
    curl -L -O https://github.com/MiniZinc/MiniZincIDE/releases/download/2.2.3/MiniZincIDE-2.2.3-bundle-linux-x86_64.tgz
    tar -xzf MiniZincIDE-2.2.3-bundle-linux-x86_64.tgz
    gen_runscript minizinc minizinc /opt/minizinc/MiniZincIDE-2.2.3-bundle-linux/bin
}

# ---------------------------------------------------------------------------
# Picat: http://picat-lang.org/

install_picat() {
    mkdir -p /opt/picat
    cd /opt/picat
    curl -O http://picat-lang.org/download/picat26_linux64.tar.gz
    tar -xzf picat26_linux64.tar.gz
    gen_runscript picat picat /opt/picat/Picat
}

# ---------------------------------------------------------------------------
# XSB: http://xsb.sourceforge.net/

install_xsb() {
    mkdir -p /opt/xsb
    cd /opt/xsb
    curl -L https://sourceforge.net/projects/xsb/files/xsb/3.8%20Three-Buck%20Chuck/XSB38.tar.gz/download > XSB38.tar.gz
    tar -xzf XSB38.tar.gz
    cd XSB/build
    ./configure
    ./makexsb
    gen_runscript xsb xsb /opt/xsb/XSB/bin
}

# ---------------------------------------------------------------------------
# Ciao: https://ciao-lang.org/

install_ciao() {
    mkdir -p /opt/ciao
    cd /opt
    git clone https://github.com/ciao-lang/ciao
    cd /opt/ciao
    ./ciao-boot.sh local-install
    gen_runscript ciao ciaosh /opt/ciao/build/bin
}

# ---------------------------------------------------------------------------
# SWI: http://www.swi-prolog.org/

install_swipl() {
    apt-get install -y swi-prolog
    gen_runscript1 swipl swipl 
}

# ===========================================================================

systems="clingo eclipseclp idp minizinc picat xsb ciao swipl"

for i in $systems; do
    install_$i
done

