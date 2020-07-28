FROM sagemathinc/cocalc-kubernetes-server

LABEL MAINTAINER Gabriel Gazola Milan <gabriel.milan@lps.ufrj.br>

USER root
SHELL [ "/bin/bash", "-c" ]
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV KUBERNETES_REGISTRY lpsufrj
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen
ENV TS_TRANSPILE_ONLY true
ENV DEBIAN_FRONTEND noninteractive
ENV COCALC_KUBERNETES yes

CMD /root/run.py

EXPOSE 80 443
