#====================================================================
#
# Build
# $ docker build -t meshoptimizer-test -f ./test/Docker/Dockerfile .
#
# Run
# $ docker run -it -v ~/:/mnt/home meshoptimizer-test
#
# Cleanup
# $ docker system prune -f
#
#====================================================================

FROM debian:11 AS meshoptimizer

# Set timezone
ARG TZ="Europe/Berlin"
ENV TZ $TZ
RUN echo ${TZ} > /etc/timezone

# Automated
ENV DEBIAN_FRONTEND=noninteractive


#--------------------------------------------------------------------
# Install Build Dependencies
RUN \
       apt-get -yq update \
    && apt-get -yq install build-essential cmake g++


#--------------------------------------------------------------------
# Build and install meshoptimizer

# Copy local code
ADD . /code/meshoptimizer

RUN \
       mkdir -p /code \
    && cd /code/meshoptimizer \
    && cmake . -B ./bld -DMESHOPT_BUILD_GLTFPACK=ON \
    && cmake --build ./bld -j8 \
    && cmake --install ./bld


#--------------------------------------------------------------------
# Setup to run
RUN \
       mkdir -p /mnt/home \
    && mkdir -p /app \
    && cd /app \
    && echo "gltfpack -si 0.1 -v -i" >> /root/.bash_history

WORKDIR /app

CMD /bin/bash
