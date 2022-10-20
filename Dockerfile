FROM debian:11
RUN apt update && apt-get install --no-install-recommends -y \
    python3 \
    make \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi

RUN apt install -y qemu-system-arm
RUN apt install -y gcc u-boot-tools bison flex