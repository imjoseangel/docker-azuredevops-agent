FROM ubuntu:bionic

LABEL maintainer="@imjoseangel"

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
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

WORKDIR /azp

ADD start.sh /start.sh
ADD web.py /web.py
RUN chmod +x /start.sh

EXPOSE 8080

ENTRYPOINT ["/start.sh"]
