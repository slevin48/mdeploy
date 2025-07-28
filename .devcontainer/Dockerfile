# Base image for Codespaces (Ubuntu 22.04)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install libraries MCR expects + tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl unzip ca-certificates \
    libx11-6 libxt6 libxmu6 libxpm4 libxi6 libxrender1 libxrandr2 libxcursor1 \
    libxfixes3 libxdamage1 libxinerama1 libglib2.0-0 libfontconfig1 libxtst6 \
    libnss3 libasound2 libglu1-mesa libgl1-mesa-glx libxcomposite1 libxshmfence1 \
    python3 python3-pip \
 && rm -rf /var/lib/apt/lists/*

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

# Set runtime path for Linux shells/processes
ENV MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64
