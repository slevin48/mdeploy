# Base image for Codespaces (Ubuntu 22.04)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install basic tools + pull in MATLAB Runtime dependencies from MathWorks repo
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      curl unzip ca-certificates wget xargs && \
    \
    # Fetch and install the official MATLAB deps list
    MATLAB_DEPS_URL="https://raw.githubusercontent.com/mathworks-ref-arch/container-images/main/matlab-deps/r2025a/ubuntu22.04/base-dependencies.txt" && \
    wget -q "${MATLAB_DEPS_URL}" -O /tmp/matlab-deps.txt && \
    xargs -a /tmp/matlab-deps.txt -r apt-get install --no-install-recommends -y && \
    \
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/matlab-deps.txt

# Choose the MATLAB Runtime release/update that matches your compiled app
# (change these ARGs as needed; if there’s no update yet, use UPDATE=0 and adjust the URL accordingly)
ARG MCR_RELEASE=R2025a
ARG MCR_UPDATE=1

# Install MATLAB Runtime silently into /opt/matlab/matlab_runtime/<release>
WORKDIR /tmp/mcr
RUN curl -sSL -o mcr.zip \
      "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip" && \
    unzip -q mcr.zip && \
    ./install -mode silent -agreeToLicense yes -destinationFolder /opt/matlab/matlab_runtime/ && \
    rm -rf /tmp/mcr

# Set runtime path for Linux shells/processes
ENV MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\
$MCRROOT/runtime/glnxa64:\
$MCRROOT/bin/glnxa64:\
$MCRROOT/sys/os/glnxa64:\
$MCRROOT/extern/bin/glnxa64
