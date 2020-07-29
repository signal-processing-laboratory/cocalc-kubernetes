#!/bin/bash

# Defining stuff
VENV_NAME="atlas_env"
CMAKE_VERSION="3.17.2"
ROOT_VERSION="6.20.06"
INITIAL_DIR=$(pwd)
VENV_PATH="$INITIAL_DIR/$VENV_NAME"
CPU_N=$(grep -c ^processor /proc/cpuinfo)
START=false
INSTALL_PIP=false
INSTALL_SAPHYRA=false
INSTALL_ROOT=false
INSTALL_PROMETHEUS=false

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "generate_envs.sh - Script for virtualenv generation for ATLAS/Ringer users"
      echo " "
      echo "./generate_envs.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help                show this message"
      echo "--raw                     generates a raw virtual environment"
      echo "--pip                     installs pip packages on requirements.txt"
      echo "--saphyra                 installs the Saphyra framework"
      echo "--root                    installs ROOT framework"
      echo "--prometheus              install the Prometheus framework"
      exit 0
      ;;
    --raw)
      START=true
      shift
      ;;
    --pip)
      echo "--> Will install pip packages"
      START=true
      INSTALL_PIP=true
      shift
      ;;
    --saphyra)
      echo "--> Will install Saphyra"
      START=true
      INSTALL_SAPHYRA=true
      shift
      ;;
    --root)
      echo "--> Will install ROOT"
      START=true
      INSTALL_ROOT=true
      shift
      ;;
    --prometheus)
      echo "--> Will install Prometheus"
      START=true
      INSTALL_PROMETHEUS=true
      shift
      ;;
    --kolmov)
      echo "--> Will install kolmov"
      START=true
      INSTALL_KOLMOV=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Creating virtual environment
if [ "$START" = true ] ; then
  echo "--> Creating virtual environment..."
  virtualenv $VENV_NAME --python=python3
else
  echo "generate_envs.sh - Script for virtualenv generation for ATLAS/Ringer users"
  echo " "
  echo "./generate_envs.sh [options]"
  echo " "
  echo "options:"
  echo "-h, --help                show this message"
  echo "--raw                     generates a raw virtual environment"
  echo "--pip                     installs pip packages on requirements.txt"
  echo "--saphyra                 installs the Saphyra framework"
  echo "--kolmov                  installs the Kolmov framework"
  echo "--root                    installs ROOT framework"
  echo "--prometheus              install the Prometheus framework"
  exit 0
fi

# Installing PyPI packages
if [ "$INSTALL_PIP" = true ] ; then
  echo "--> Installing pip packages..."
  ./$VENV_NAME/bin/pip install -U pip
  ./$VENV_NAME/bin/pip install -U -r requirements.txt
fi

# Adding saphyra
if [ "$INSTALL_SAPHYRA" = true ] ; then
  echo "--> Installing Saphyra..."
  ./$VENV_NAME/bin/pip install -U saphyra
fi

# Adding kolmov
if [ "$INSTALL_KOLMOV" = true ] ; then
  echo "--> Installing Kolmov..."
  ./$VENV_NAME/bin/pip install -U kolmov
fi

# Adding ROOT
if [ "$INSTALL_ROOT" = true ] ; then
  apt update -y
  apt install -y git dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev gfortran libssl-dev libpcre3-dev libglew1.5-dev libftgl-dev libldap2-dev python-dev python3-dev libxml2-dev libkrb5-dev libgsl0-dev libqt4-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libboost-all-dev vim screen htop python3-pip coreutils python python3 git subversion python-numpy python3-numpy python-scipy python3-scipy python-matplotlib python3-matplotlib ipython python-pandas python3-pandas python-sympy python3-sympy python-nose python3-nose
  apt install -y wget
  wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.sh -P /usr/
  chmod 755 /usr/cmake-$CMAKE_VERSION-Linux-x86_64.sh
  cd /usr && ./cmake-$CMAKE_VERSION-Linux-x86_64.sh --skip-license
  cd $INITIAL_DIR/$VENV_NAME && wget https://root.cern/download/root_v$ROOT_VERSION.source.tar.gz && tar xfv root_v$ROOT_VERSION.source.tar.gz && rm root_v$ROOT_VERSION.source.tar.gz
  cd root-$ROOT_VERSION/ && mkdir build
  cd build/ && cmake -DPYTHON_EXECUTABLE=../../bin/python3 -Dpython3=ON -Dpython_version=3 ..
  make -j$CPU_N
  cd lib
  cp -r * ../../../lib/*/*/.
  for file in $VENV_PATH/root-$ROOT_VERSION/build/lib
  do
    ln -sf $file $VENV_PATH/lib/*/*/
  done
  export ROOT_DIR=$VENV_PATH/root-$ROOT_VERSION
  source $VENV_PATH/root-$ROOT_VERSION/build/bin/thisroot.sh
  echo 'source $VENV_PATH/root-$ROOT_VERSION/build/bin/thisroot.sh' >> ~/.bashrc
  echo 'export ROOT_DIR=$VENV_PATH/root' >> ~/.bashrc
fi


# Adding Prometheus
if [ "$INSTALL_PROMETHEUS" = true ] ; then
  echo "--> Installing Prometheus..."
  source $VENV_PATH/root-$ROOT_VERSION/build/bin/thisroot.sh
  cd $VENV_PATH && git clone https://github.com/jodafons/prometheus.git
  cd $VENV_PATH/prometheus && source setup_module.sh
  cd $VENV_PATH/prometheus && source setup_module.sh --head
  cd $VENV_PATH/prometheus && mkdir build
  cd $VENV_PATH/prometheus/build && cmake ..
  cd $VENV_PATH/prometheus/build && make
  source $VENV_PATH/prometheus/setup.sh
  cp -r $VENV_PATH/prometheus/build/python/* $VENV_PATH/lib/*/*/.
  for file in $VENV_PATH/prometheus/build/lib
  do
    ln -sf $file $VENV_PATH/lib/*/*/
  done
  for file in $VENV_PATH/prometheus/build/python
  do
    ln -sf $file $VENV_PATH/lib/*/*/
  done
fi
