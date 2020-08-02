#!/bin/bash
set -ev

# !!!NOTE!!! This script is intended to be run as the sage user NOT root.
SAGE_SRC_TARGET=${1%/}
BRANCH=$2

if [ -z $SAGE_SRC_TARGET ]; then
  >&2 echo "Must specify a target directory for the sage source checkout"
  exit 1
fi

if [ -z $BRANCH ]; then
  >&2 echo "Must specify a branch to build"
  exit 1
fi

N_CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

export SAGE_FAT_BINARY="yes"
# Just to be sure Sage doesn't try to build its own GCC (even though
# it shouldn't with a recent GCC package from the system and with gfortran)
export SAGE_INSTALL_GCC="no"
export MAKE="make -j${N_CORES}"
cd "$SAGE_SRC_TARGET"
git clone --depth 1 --branch ${BRANCH} https://github.com/sagemath/sage.git
cd sage

# This may fail: https://trac.sagemath.org/ticket/23519
make || true
# Because of "stupid" static GMP's get left around that break the build.
# So we try again with the static GMP's removed.
rm "$SAGE_SRC_TARGET"/sage/local/lib/libgmp*.a
make

# Clean up artifacts from the sage build that we don't need for runtime or
# running the tests
#
# Unfortunately none of the existing make targets for sage cover this ground
# exactly

cd "$SAGE_SRC_TARGET"/sage/
make misc-clean
make -C src/ clean

rm -rf upstream/
rm -rf src/doc/output/doctrees/

# Strip binaries -- this saves gigabytes of space and takes a while...
LC_ALL=C find local/lib local/bin -type f -exec strip '{}' ';' 2>&1 | grep -v "File format not recognized" |  grep -v "File truncated" || true
