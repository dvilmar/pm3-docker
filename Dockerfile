FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates build-essential pkg-config \
    libreadline-dev \
    libusb-1.0-0-dev libbz2-dev libbluetooth-dev \
    libpython3-dev libssl-dev qtbase5-dev libqt5svg5-dev \
    liblz4-dev libjpeg-dev \
    usbutils sudo \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/RfidResearchGroup/proxmark3.git /opt/proxmark3

WORKDIR /opt/proxmark3

RUN make clean && make client -j$(nproc)

ENV PATH="/opt/proxmark3/client:${PATH}"

WORKDIR /root
CMD ["/bin/bash"]
