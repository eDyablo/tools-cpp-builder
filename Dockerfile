ARG CONTAINER_IMAGE_REGISTRY

FROM ${CONTAINER_IMAGE_REGISTRY:+$CONTAINER_IMAGE_REGISTRY/}alpine:3.20.3 AS base

FROM base AS build

RUN apk update && apk upgrade --no-cache

RUN apk add --no-cache \
  cmake=3.29.3-r0 \
  g++=13.2.1_git20240309-r0 \
  git=2.45.3-r0 \
  make=4.4.1-r2

WORKDIR /var/workspace

COPY . .

RUN \
  mkdir -p build \
  && cd build \
  && cmake .. \
  && make install

FROM base

COPY --from=build /usr/local /usr/local

RUN apk add --no-cache \
  cmake=3.29.3-r0 \
  g++=13.2.1_git20240309-r0 \
  git=2.45.3-r0 \
  make=4.4.1-r2

ONBUILD WORKDIR /var/workspace

ONBUILD ARG SRC_DIR_PATH

ONBUILD COPY ${SRC_DIR_PATH} .

ONBUILD ARG CMAKE_TARGET

ONBUILD RUN \
  mkdir -p build \
  && cd build \
  && cmake .. \
  && make ${CMAKE_TARGET} \
  && ctest --no-tests=ignore --verbose .
