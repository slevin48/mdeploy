# Base image for Codespaces (Ubuntu 24.04)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC"

RUN apt-get update && apt-get install --no-install-recommends -y \
ca-certificates \
gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good \
gstreamer1.0-tools \
libasound2t64 \
libatomic1 \
libc6 \
libcairo-gobject2 \
libcairo2 \
libcap2 \
libcups2t64 \
libdrm2 \
libfontconfig1 \
libfribidi0 \
libgbm1 \
libgdk-pixbuf-2.0-0 \
libgl1 \
libglib2.0-0t64 \
libgstreamer-plugins-base1.0-0 \
libgstreamer1.0-0 \
libgtk-3-0t64 \
libgtk2.0-0t64 \
libice6 \
libltdl7 \
libnettle8t64 \
libnspr4 \
libnss3 \
libpam0g \
libpango-1.0-0 \
libpangocairo-1.0-0 \
libpangoft2-1.0-0 \
libpixman-1-0 \
libsndfile1 \
libtirpc3t64 \
libuuid1 \
libwayland-client0 \
libxcomposite1 \
libxcursor1 \
libxdamage1 \
libxfixes3 \
libxfont2 \
libxft2 \
libxinerama1 \
libxrandr2 \
libxt6t64 \
libxtst6 \
libxxf86vm1 \
net-tools \
procps \
unzip \
zlib1g \
    && apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

RUN [ -d /usr/share/X11/xkb ] || mkdir -p /usr/share/X11/xkb

# Choose the MATLAB Runtime release/update that matches your compiled app
# (change these ARGs as needed; if there’s no update yet, use UPDATE=0 and adjust the URL accordingly)
ARG MCR_RELEASE=R2024b
ARG MCR_UPDATE=6

# Install MATLAB Runtime silently into /opt/matlab/matlab_runtime/<release>
RUN curl -L -o mcr.zip \
  "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip" \
    && unzip -q mcr.zip -d /tmp/mcr \
    && /tmp/mcr/install -mode silent -agreeToLicense yes -destinationFolder /opt/matlab/matlab_runtime/ \
    && rm mcr.zip && rm -rf /tmp/mcr

# Install Python, pip, venv, and git
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv git && \
    rm -rf /var/lib/apt/lists/*

# Set runtime path for Linux shells/processes
ENV MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64
