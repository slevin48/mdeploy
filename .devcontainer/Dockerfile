# Copyright 2025 The MathWorks, Inc.

FROM ubuntu:24.04

# Non-interactive installation
ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC"

# Copy and install OS-level dependencies
COPY base-dependencies.txt /tmp/base-dependencies.txt
RUN apt-get update && \
    xargs -a /tmp/base-dependencies.txt apt-get install --no-install-recommends -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure X11 keyboard layout directory exists
RUN mkdir -p /usr/share/X11/xkb

# MATLAB Runtime version configuration
ARG MCR_RELEASE=R2025a
ARG MCR_UPDATE=1

# Download and install MATLAB Runtime
WORKDIR /tmp/mcr
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl unzip && \
    curl -sSL -o mcr.zip \
      "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip" && \
    unzip -q mcr.zip && \
    ./install -mode silent -agreeToLicense yes -destinationFolder /opt/matlab/matlab_runtime && \
    rm -rf /tmp/mcr /var/lib/apt/lists/*

# Set MATLAB Runtime environment variables
ENV MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:\
    $MCRROOT/runtime/glnxa64: \
    $MCRROOT/bin/glnxa64: \
    $MCRROOT/sys/os/glnxa64: \
    $MCRROOT/extern/bin/glnxa64

# Return to root for any further steps
WORKDIR /