FROM geoedf/standalone:v183

USER root

RUN mkdir /images && \
    chown jovyan: /images && \
    chmod 755 /images

RUN pip install hpccm nbgitpuller

USER ${NB_UID}

COPY geoedf.cfg /home/jovyan/.config/

COPY run.sh /usr/local/bin
