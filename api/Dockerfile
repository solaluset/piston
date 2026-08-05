FROM buildpack-deps:trixie AS isolate
COPY ./isolate.patch /tmp
RUN apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev libseccomp-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate/ && \
    cd /tmp/isolate && \
    git checkout cf03a9025adaec7d281b7fce805592e41a1d955a && \
    git apply /tmp/isolate.patch && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

FROM node:current-trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg-reconfigure -p critical dash
RUN apt-get update && \
    apt-get install -y libxml2 gnupg tar coreutils util-linux libc6-dev \
    binutils build-essential locales libevent-dev libgmp3-dev \
    libncurses6 libedit-dev libseccomp-dev rename procps python3 \
    libreadline-dev libblas-dev liblapack-dev libarpack2-dev \
    libfftw3-dev libglpk-dev libqhull-dev libqrupdate-dev libsuitesparse-dev \
    libsundials-dev libpcre2-dev libcap-dev && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -M piston
COPY --from=isolate /usr/local/bin/isolate /usr/local/bin
COPY --from=isolate /usr/local/etc/isolate /usr/local/etc/isolate

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /piston_api
COPY ["package.json", "package-lock.json", "./"]
RUN npm install
COPY ./src ./src

CMD ["/piston_api/src/docker-entrypoint.sh"]
EXPOSE 2000/tcp
