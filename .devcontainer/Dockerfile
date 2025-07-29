# Base image for Codespaces (Ubuntu 24.04)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC"

COPY base-dependencies.txt /tmp/base-dependencies.txt

RUN apt-get update && apt-get install --no-install-recommends -y `cat /tmp/base-dependencies.txt` \
    && apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

RUN [ -d /usr/share/X11/xkb ] || mkdir -p /usr/share/X11/xkb

# Choose the MATLAB Runtime release/update that matches your compiled app
# (change these ARGs as needed; if there’s no update yet, use UPDATE=0 and adjust the URL accordingly)
ARG MCR_RELEASE=R2024b
ARG MCR_UPDATE=6

# Install MATLAB Runtime silently into /opt/matlab/matlab_runtime/<release>
WORKDIR /tmp/mcr
RUN curl -L -o mcr.zip \
  "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip" \
 && unzip -q mcr.zip \
 && ./install -mode silent -agreeToLicense yes -destinationFolder /opt/matlab/matlab_runtime/ \
 && rm -rf /tmp/mcr

# Install Python, pip, venv, and git
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv git && \
    rm -rf /var/lib/apt/lists/*

# Set runtime path for Linux shells/processes
ENV MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64
