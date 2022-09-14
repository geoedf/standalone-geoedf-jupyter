FROM jupyter/base-notebook

USER root

RUN apt-get update && apt-get -y install gnupg2 wget curl vim

# Install Pegasus from repos
RUN wget -O - http://download.pegasus.isi.edu/pegasus/gpg.txt | apt-key add - 

RUN echo 'deb [arch=amd64] http://download.pegasus.isi.edu/pegasus/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/pegasus.list

RUN apt-get update && apt-get -y install pegasus

WORKDIR /opt

# Install Condor
RUN curl -fsSL https://get.htcondor.org | /bin/bash -s -- --download 

RUN tar -x -f condor.tar.gz && \
    mv condor-*stripped condor

# owned by jovyan so it can start the condor service
RUN chown -R "${NB_USER}:${NB_GID}" /opt/condor

# install singularity
RUN apt-get update && apt-get install -y \
    build-essential \
    libseccomp-dev \
    libssl-dev \
    pkg-config \
    squashfs-tools \
    cryptsetup

WORKDIR /tmp

RUN export VERSION=1.17.2 OS=linux ARCH=amd64 && \ 
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \ 
    rm go$VERSION.$OS-$ARCH.tar.gz

RUN export PATH=/usr/local/go/bin:$PATH && \
    export VERSION=3.8.0 && \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION} && \
    ./mconfig --without-suid && \
    make -C builddir && \
    make -C builddir install

# create /data dir to hold temporary workflow outputs
RUN mkdir /data && chown "${NB_USER}:${NB_GID}" /data

# add singularity remote config
COPY config/remote.yaml /usr/local/etc/singularity/remote.yaml

USER ${NB_UID}

# install Pegasus dependencies and GeoEDF engine
RUN pip3 install pyyaml GitPython geoedfengine==1.83

# ensure Pegasus in Python path
ENV PYTHONPATH=/usr/lib/python3.6/dist-packages/:$PYTHONPATH

ENV PATH=/usr/local/go/bin:$PATH

RUN cd /opt/condor && ./bin/make-personal-from-tarball

WORKDIR "${HOME}"

#RUN mkdir images

# set GeoEDF env, the config file will be deposited via 
# a secret mounted into volume in Kubernetes
ENV GEOEDF_CONFIG="${HOME}"/.config/geoedf.cfg

# start condor service
COPY run.sh /usr/local/bin/
