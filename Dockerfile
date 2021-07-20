FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y \
       build-essential \
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
       git \
       automake && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/apache/arrow.git

ENV VIRTUAL_ENV=/root/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV ARROW_HOME=/dist
ENV LD_LIBRARY_PATH=/dist/lib:$LD_LIBRARY_PATH


RUN mkdir arrow/cpp/build && \
    ( \
        cd arrow/cpp/build && \
        cmake -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
            -DCMAKE_INSTALL_LIBDIR=lib \
            -DARROW_WITH_BZ2=ON \
            -DARROW_WITH_ZLIB=ON \
            -DARROW_WITH_ZSTD=ON \
            -DARROW_WITH_LZ4=ON \
            -DARROW_WITH_SNAPPY=ON \
            -DARROW_WITH_BROTLI=ON \
            -DARROW_PARQUET=ON \
            -DARROW_PYTHON=ON \
            -DARROW_BUILD_TESTS=ON \
            .. && \
            make -j4 && \
            make install \
    )

RUN python3 -m virtualenv -p python3 ${VIRTUAL_ENV} && \
        pip3 install \
            cmake \
            numpy && \
        cd /arrow/python && \
        pip3 install -r requirements-build.txt && \
        python3 setup.py install