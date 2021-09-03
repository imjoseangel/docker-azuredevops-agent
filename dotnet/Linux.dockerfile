FROM ubuntu:focal

LABEL maintainer="@imjoseangel"

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# **********************************************
# Set common components
# **********************************************

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    apt-transport-https \
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
    libssl1.1 \
    libunwind8 \
    curl \
    wget \
    gnupg2 \
    netcat \
    python3 \
    python3-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*


RUN curl http://ftp.debian.org/debian/pool/main/i/icu/libicu63_63.2-3_amd64.deb \
    --output libicu63_63.2-3_amd64.deb && dpkg -i libicu63_63.2-3_amd64.deb

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    kubeadm kubelet kubectl kubernetes-cni

RUN pip3 install --upgrade \
    setuptools \
    pip

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*


# **********************************************
# Install dotnet components
# **********************************************
#Setup PPA
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb  -O packages-microsoft-prod.deb | bash \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Install .net Core
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dotnet-sdk-2.1 \
    dotnet-sdk-2.2 \
    dotnet-sdk-3.1 \
    dotnet-sdk-5.0 \
    aspnetcore-runtime-5.0

# **********************************************
# Install NodeJS & Powershell
# **********************************************
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    npm nodejs powershell

# **********************************************
# Install AzureDevops Agents
# **********************************************

WORKDIR /azp

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD stop.sh /stop.sh
RUN chmod +x /stop.sh

RUN groupadd -g 1001 azp && \
    useradd -r -u 1001 -g azp azp

RUN chown -R azp:azp /azp

#USER azp #System.UnauthorizedAccessException: Access to the path '/home/azp/.dotnet' is denied.

ENTRYPOINT ["/start.sh"]
