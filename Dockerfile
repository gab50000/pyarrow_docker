FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y \
       libjemalloc-dev \
       libboost-dev \
       libboost-filesystem-dev \
       libboost-system-dev \
       libboost-regex-dev \
       python-dev \
       autoconf \
       flex \
       bison \
       python3-dev \
       python3-virtualenv \
       git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/apache/arrow.git
