ARG BUILD_FROM=ghcr.io/erik73/base-python/amd64:1.0.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
ENV LANG C.UTF-8

# Install Telldus library for TellStick (using same approach as in hassio docker installation)
RUN apk add --no-cache \
        confuse \
        libftdi1 \
        libstdc++ \
        socat \
    && apk add --no-cache --virtual .build-dependencies \
        argp-standalone \
        build-base \
        cmake \
        confuse-dev \
        gcc \
        git \
        libftdi1-dev \
    && ln -s /usr/include/libftdi1/ftdi.h /usr/include/ftdi.h \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone -b v2.1.3-beta1 --depth 1 https://github.com/telldus/telldus \
    && cd telldus/telldus-core \
    && sed -i \
        "/\<sys\/socket.h\>/a \#include \<sys\/select.h\>" \
        common/Socket_unix.cpp \
    && cmake . \
        -DBUILD_LIBTELLDUS-CORE=ON \
        -DBUILD_TDADMIN=OFF \
        -DBUILD_TDTOOL=ON \
        -DGENERATE_MAN=OFF \
        -DFORCE_COMPILE_FROM_TRUNK=ON \
        -DFTDI_LIBRARY=/usr/lib/libftdi1.so \
    && make \
    && make install \
    && pip install --no-cache-dir \ 
       tellcore-py \
    && cd /usr/src/ \
    && git clone -b master --depth 1 https://github.com/erijo/tellive-py \
    && cd tellive-py \
    && python setup.py install \
    && apk del .build-dependencies \
    && rm -rf /usr/src/telldus \
    && rm -rf /usr/src/tellive-py \
    && cd /

# Copy data for add-on
COPY rootfs /

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Erik73 Hassio-Addons" \
    org.opencontainers.image.authors="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/erik73/hassio-addons" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
