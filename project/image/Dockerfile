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
RUN pip3 install -U virtualenv
RUN mkdir /usr/env && cd /usr/env && mkdir atlas-env && cd atlas-env
COPY generate_env.sh /usr/env/atlas-env/generate_env.sh
COPY requirements.txt /usr/env/atlas-env/requirements.txt
RUN cd /usr/env/atlas-env/ && ./generate_env.sh --pip --saphyra --root
COPY kernels/atlas /usr/local/share/jupyter/kernels/atlas

USER user
WORKDIR /home/user
EXPOSE 2222 6000 6001

ENTRYPOINT ["/cocalc/bin/tini", "--"]
CMD ["sh", "-c", "env -i /cocalc/init/init.sh $COCALC_PROJECT_ID"]
