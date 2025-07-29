# Input arguments (optional)
# (Default values)
ARG MCRINSTALLER=MATLAB_Runtime_R2024b_Update_6_glnxa64.zip
ARG MCR_RELEASE=R2024b

FROM mathworks/matlab-deps:${MCR_RELEASE} as installer

ARG MCRINSTALLER

# Copy MCR installer zip into container
RUN mkdir /mcr-install
ADD ${MCRINSTALLER} /mcr-install/
# ADD installer_input.txt /mcr-install/

# Install MCR
#RUN cd /mcr-install && unzip ${MCRINSTALLER} && ./install -inputFile installer_input.txt
RUN cd /mcr-install && unzip ${MCRINSTALLER} && ./install -mode silent -agreeToLicense yes -destinationFolder /usr/local/MATLAB/MATLAB_Runtime 

# Remove install binaries
RUN rm -rf mcr-install

# Second stage in build
FROM mathworks/matlab-deps:${MCR_RELEASE} as product

ARG MCR_RELEASE

COPY --from=installer /usr/local/MATLAB /usr/local/MATLAB
	
# Install Python, pip, venv, and git
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 python3-pip python3-venv git \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && rm -rf /var/lib/apt/lists/*

# Set runtime path for Linux shells/processes
ENV MCRROOT=/usr/local/MATLAB/MATLAB_Runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64