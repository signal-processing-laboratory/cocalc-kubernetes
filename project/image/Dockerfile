FROM sagemathinc/cocalc-kubernetes-project

ARG INITIAL_DIR="/usr/env/atlas-env"
ARG VENV_NAME="atlas_env"
ARG VENV_PATH="${INITIAL_DIR}/${VENV_NAME}"
ARG CMAKE_VERSION="3.19.5"
ARG ROOT_VERSION="6.20.06"

LABEL MAINTAINER Gabriel Gazola Milan <gabriel.milan@lps.ufrj.br>

USER root
SHELL [ "/bin/bash", "-c" ]
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV KUBERNETES_REGISTRY ringeratlas
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen

#
# ATLAS kernel
#
RUN pip3 install --upgrade pip
RUN pip3 install -U virtualenv ipykernel
# Setup virtual env
RUN mkdir -p /usr/env/atlas-env
WORKDIR /usr/env/atlas-env
COPY requirements.txt ./requirements.txt
RUN virtualenv ${VENV_NAME} --python=python3
# Pip packages
RUN ./atlas_env/bin/python -m pip install -U pip
RUN ./atlas_env/bin/python -m pip install -U -r requirements.txt
# ROOT
RUN apt update -y
RUN apt install -y git dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev gfortran libssl-dev libpcre3-dev libglew1.5-dev libftgl-dev libldap2-dev python-dev python3-dev libxml2-dev libkrb5-dev libgsl0-dev libqt4-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev libboost-all-dev vim screen htop python3-pip coreutils python python3 git subversion python-numpy python3-numpy python-scipy python3-scipy python-matplotlib python3-matplotlib ipython python-pandas python3-pandas python-sympy python3-sympy python-nose python3-nose
RUN apt install -y wget
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh -P /usr/
RUN chmod 755 /usr/cmake-${CMAKE_VERSION}-Linux-x86_64.sh
RUN cd /usr && ./cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license
RUN cd ${VENV_NAME} && wget https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz && tar xfv root_v${ROOT_VERSION}.source.tar.gz && rm root_v${ROOT_VERSION}.source.tar.gz
RUN cd ${VENV_NAME}/root-${ROOT_VERSION}/ && mkdir -p build
RUN cd ${VENV_NAME}/root-${ROOT_VERSION}/build/ && cmake -DPYTHON_EXECUTABLE=../../bin/python3 -Dpython3=ON -Dpython_version=3 ..
RUN cd ${VENV_NAME}/root-${ROOT_VERSION}/build/ && make -j$(grep -c ^processor /proc/cpuinfo)
RUN cd ${VENV_NAME}/root-${ROOT_VERSION}/build/lib && cp -r * ../../../lib/*/*/.
RUN cd ${VENV_NAME}/root-${ROOT_VERSION}/build/lib && for file in ${VENV_PATH}/root-${ROOT_VERSION}/build/lib/*; do ln -sf $file ${VENV_PATH}/lib/*/*/; done
ENV ROOT_DIR=${VENV_PATH}/root-${ROOT_VERSION}
RUN source $ROOT_DIR/build/bin/thisroot.sh
# Prometheus
RUN cd ${VENV_PATH} && git clone https://github.com/ringer-atlas/prometheus.git
RUN cd ${VENV_PATH}/prometheus && mkdir build
RUN cd ${VENV_PATH}/prometheus/build && cmake ..
RUN cd ${VENV_PATH}/prometheus/build && make -j$(grep -c ^processor /proc/cpuinfo)
RUN cp -r ${VENV_PATH}/prometheus/build/python/* ${VENV_PATH}/lib/*/*/.
RUN for file in ${VENV_PATH}/prometheus/build/lib/*; do ln -sf $file ${VENV_PATH}/lib/*/*/; done
RUN for file in ${VENV_PATH}/prometheus/build/python/*; do ln -sf $file ${VENV_PATH}/lib/*/*/; done
RUN for file in ${VENV_PATH}/prometheus/scripts/*; do ln -sf $file /usr/bin/*/*/; done
ENV PRT_PATH=${VENV_PATH}/prometheus/
# Kolmov
RUN cd ${VENV_PATH} && git clone https://github.com/ringer-atlas/kolmov.git
RUN ${VENV_PATH}/bin/pip install ${VENV_PATH}/kolmov/.
# Saphyra
RUN cd ${VENV_PATH} && git clone https://github.com/ringer-atlas/saphyra.git
RUN ${VENV_PATH}/bin/pip install ${VENV_PATH}/saphyra/.
# Orchestra
RUN cd ${VENV_PATH} && git clone https://github.com/ringer-atlas/orchestra.git
RUN ${VENV_PATH}/bin/pip install ${VENV_PATH}/orchestra/.
ENV ORCHESTRA_PATH=${VENV_PATH}/orchestra/
# Kernel configuration
COPY kernels/atlas /usr/local/share/jupyter/kernels/atlas

USER user
WORKDIR /home/user
EXPOSE 2222 6000 6001

ENTRYPOINT ["/cocalc/bin/tini", "--"]
CMD ["sh", "-c", "env -i /cocalc/init/init.sh $COCALC_PROJECT_ID"]
