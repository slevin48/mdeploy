# .devcontainer/install_mcr.sh
set -euxo pipefail
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl unzip ca-certificates \
  libx11-6 libxt6 libxmu6 libxpm4 libxi6 libxrender1 libxrandr2 libxcursor1 \
  libxfixes3 libxdamage1 libxinerama1 libglib2.0-0 libfontconfig1 libxtst6 \
  libnss3 libasound2 libglu1-mesa libgl1-mesa-glx libxcomposite1 libxshmfence1

MCR_RELEASE=R2025a
MCR_UPDATE=1
MCRROOT=/opt/matlab/matlab_runtime/${MCR_RELEASE}

tmp=$(mktemp -d)
cd "$tmp"
curl -L -o mcr.zip \
  "https://ssd.mathworks.com/supportfiles/downloads/${MCR_RELEASE}/Release/${MCR_UPDATE}/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_${MCR_RELEASE}_Update_${MCR_UPDATE}_glnxa64.zip"
unzip -q mcr.zip
sudo ./install -mode silent -agreeToLicense yes -destinationFolder "$MCRROOT"
sudo bash -lc "echo 'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64' >/etc/profile.d/mcr.sh"
rm -rf "$tmp"
