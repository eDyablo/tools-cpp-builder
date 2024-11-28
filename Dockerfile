ARG CONTAINER_IMAGE_REGISTRY

FROM ${CONTAINER_IMAGE_REGISTRY:+$CONTAINER_IMAGE_REGISTRY/}alpine:3.20.3

RUN apk add --update --no-cache \
  cmake=3.29.3-r0 \
  g++=13.2.1_git20240309-r0 \
  git=2.45.2-r0 \
  make=4.4.1-r2

WORKDIR /var/workspace

ONBUILD WORKDIR /var/workspace

ONBUILD ARG SRC_DIR_PATH=.

ONBUILD COPY ${SRC_DIR_PATH} .

ONBUILD ARG CMAKE_PROJECT_NAME

ONBUILD RUN \
  mkdir -p build \
  && cd build \
  && cmake .. \
  && make ${CMAKE_PROJECT_NAME}
