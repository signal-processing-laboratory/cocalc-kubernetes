FROM sagemathinc/cocalc-kubernetes-project

LABEL MAINTAINER Gabriel Gazola Milan <gabriel.milan@lps.ufrj.br>

USER root
SHELL [ "/bin/bash", "-c" ]
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV KUBERNETES_REGISTRY lpsufrj
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen

# ATLAS kernel
RUN pip3 install --upgrade pip
RUN pip3 install -U virtualenv soundfile
RUN mkdir /usr/env && cd /usr/env && git clone https://github.com/gabriel-milan/atlas-env && cd atlas-env && ./generate_env.sh --pip --saphyra --root
COPY kernels/atlas /usr/local/share/jupyter/kernels/atlas

CMD /root/run.py

EXPOSE 443
