FROM ubuntu:focal

LABEL maintainer="@imjoseangel"

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_VERSION 19.03.4
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    ca-certificates \
    jq \
    git \
    iputils-ping \
    liblttng-ust-ctl4 \
    liblttng-ust0 \
    liburcu6 \
    libcurl4 \
    libssl1.0.0 \
    libicu60 \
    libunwind8 \
    curl \
    netcat \
    python3 \
    python3-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade \
    setuptools \
    pip

ADD requirements.txt /requirements.txt
RUN pip3 install --upgrade -r /requirements.txt

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp

RUN curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -o docker-${DOCKER_VERSION}.tgz \
    && tar xvf docker-${DOCKER_VERSION}.tgz \
    && rm -f docker-${DOCKER_VERSION}.tgz

RUN ln -sf /azp/docker/docker /usr/local/bin/docker

ADD start.sh /start.sh
# ADD web.py /web.py
RUN chmod +x /start.sh

# EXPOSE 8080

ENTRYPOINT ["/start.sh"]
