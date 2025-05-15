FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget && \
    wget https://itasca-software.s3.us-east-1.amazonaws.com/itasca-software/9.subscription/itascasoftware.latest.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install -f ./itascasoftware.latest.deb && \
    rm -f ./itascasoftware.latest.deb && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix "Apptainer container cannot load libQt6Core.so.6" on CentOS 7
RUN strip --remove-section=.note.ABI-tag /opt/itascasoftware/Qt-6.6.3/6.6.3/gcc_64/lib/libQt6Core.so.6
