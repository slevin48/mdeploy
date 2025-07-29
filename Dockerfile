ARG MCR_RELEASE=R2024b
ARG MCR_UPDATE=6

# ── Stage 1: download & install MCR ───────────────────────────────────────
FROM mathworks/matlab-deps:${MCR_RELEASE} AS installer

ARG MCR_RELEASE
ARG MCR_UPDATE

# Install tools to fetch & unzip
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       curl unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/mcr

# Download the Runtime installer ZIP
# https://ssd.mathworks.com/supportfiles/downloads/R2024b/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024b_Update_6_glnxa64.zip
RUN curl -fsSL -o mcr.zip \
      "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip"

# Unzip and perform silent install
RUN unzip mcr.zip && \
    ./install -mode silent \
               -agreeToLicense yes \
               -destinationFolder /usr/local/MATLAB/MATLAB_Runtime

# Clean up installer files
RUN rm -rf /tmp/mcr

# ── Stage 2: runtime image ────────────────────────────────────────────────
FROM mathworks/matlab-deps:${MCR_RELEASE}

ARG MCR_RELEASE

# Copy installed MCR into final image
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