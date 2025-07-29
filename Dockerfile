# Input arguments (optional)
# (Default values)
ARG MCRINSTALLER=MATLAB_Runtime_R2024b_Update_6_glnxa64.zip
# ARG MCRINSTALLER=https://ssd.mathworks.com/supportfiles/downloads/R2024b/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024b_Update_6_glnxa64.zip
ARG MCR_RELEASE=R2024b

FROM mathworks/matlab-deps:${MCR_RELEASE} as installer

ARG MCRINSTALLER

# Copy MCR installer zip into container
RUN mkdir /mcr-install
ADD ${MCRINSTALLER} /mcr-install/
ADD installer_input.txt /mcr-install/

# Install MCR
#RUN cd /mcr-install && unzip ${MCRINSTALLER} && ./install -inputFile installer_input.txt
RUN cd /mcr-install && unzip ${MCRINSTALLER} && ./install -mode silent -agreeToLicense yes -destinationFolder /usr/local/MATLAB/MATLAB_Runtime 

# Remove install binaries
RUN rm -rf mcr-install

# Second stage in build
FROM mathworks/matlab-deps:${MCR_RELEASE}

ARG MCR_RELEASE

COPY --from=installer /usr/local/MATLAB /usr/local/MATLAB
	
# Install Python, pip, venv, and git
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv git && \
    rm -rf /var/lib/apt/lists/*

# Create our virtualenv and make it the default python/PATH
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

# Copy and install local Python package
COPY mdeployPythonPackage24b/output/build/ /tmp/mdeployPythonPackage24b/output/build/
WORKDIR /tmp/mdeployPythonPackage24b/output/build
RUN pip install .

COPY streamlit_app.py /
WORKDIR /

# Set runtime path for Linux shells/processes
ENV MCRROOT=/usr/local/MATLAB/MATLAB_Runtime/${MCR_RELEASE}
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64


# Expose Streamlit’s default port
EXPOSE 8501

# Launch Streamlit
CMD ["streamlit", "run", "/streamlit_app.py", "--server.address=0.0.0.0", "--server.port=8501", "--server.fileWatcherType=poll"]
