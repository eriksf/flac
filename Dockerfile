FROM ubuntu:22.04

ARG IS_VERSION="9.4.29"

# Install system updates and flac
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gpg-agent wget && \
    wget https://itasca-software.s3.us-east-1.amazonaws.com/itasca-software/9.subscription/itascasoftware.${IS_VERSION}.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install -f ./itascasoftware.${IS_VERSION}.deb && \
    rm -f ./itascasoftware.${IS_VERSION}.deb

# Install Intel oneMKL
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y intel-oneapi-mkl && \
    cp /opt/intel/oneapi/mkl/2025.1/lib/libmkl_core.so.2 /opt/itascasoftware/subscription/ && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix "Apptainer container cannot load libQt6Core.so.6" on CentOS 7
RUN strip --remove-section=.note.ABI-tag /opt/itascasoftware/Qt-6.8.2/6.8.2/gcc_64/lib/libQt6Core.so.6

