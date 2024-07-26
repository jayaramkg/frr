# Frr Docker
#

FROM ubuntu:jammy-20240627.1
MAINTAINER your@email.address

ARG DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN apt update
RUN apt-get install -y \
    git autoconf automake libtool make libreadline-dev texinfo \
    pkg-config libpam0g-dev libjson-c-dev bison flex \
    libc-ares-dev python3-dev python3-sphinx \
    install-info build-essential libsnmp-dev perl \
    libcap-dev libelf-dev libunwind-dev \
    protobuf-c-compiler libprotobuf-c-dev

RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y libpcre2-dev
RUN apt-get install -y curl
RUN apt-get install -y graphviz
RUN apt-get install -y apt-utils
RUN apt-get install -y net-tools
RUN apt-get install -y ebtables
RUN apt-get install -y bridge-utils
RUN apt-get install -y tcpdump
RUN apt-get install -y iputils-arping
RUN apt-get install -y iputils-ping
RUN apt-get install -y arping
RUN apt-get install -y iproute2
RUN apt-get install -y tshark
RUN apt-get install -y tcptraceroute
RUN apt-get install -y traceroute
RUN apt-get install -y inetutils-tools
RUN apt-get install -y inetutils-telnet
RUN apt-get install -y inetutils-telnetd
RUN apt-get install -y inetutils-traceroute
RUN apt-get install -y inetutils-ping
RUN apt-get install -y nginx
RUN apt-get update --fix-missing
RUN apt-get install -y vim
RUN apt-get install -y autoconf
RUN apt-get install -y libtool

RUN git clone https://github.com/doxygen/doxygen.git doxygen && \
        cd doxygen && \
        mkdir build; cd build && \
        cmake -G "Unix Makefiles" .. && \
        make && \
        make install

RUN git clone https://github.com/CESNET/libyang.git libyang && \
        cd libyang && \
        git checkout v2.1.128 && \
        mkdir build; cd build && \
        cmake --install-prefix /usr \
        -D CMAKE_BUILD_TYPE:String="Release" .. && \
        make && \
        make install

RUN apt-get install -y libgrpc++-dev protobuf-compiler-grpc
RUN apt install -y libsqlite3-dev
RUN apt-get install -y libzmq5 libzmq3-dev

RUN groupadd -r -g 92 frr && \
        groupadd -r -g 85 frrvty && \
        adduser --system --ingroup frr --home /var/run/frr/ \
                --gecos "FRR suite" --shell /sbin/nologin frr && \
        usermod -a -G frrvty frr

RUN git clone https://github.com/frrouting/frr.git frr && \
        cd frr && \
        ./bootstrap.sh  && \
        ./configure \
      --prefix=/usr \
      --includedir=\${prefix}/include \
      --bindir=\${prefix}/bin \
      --sbindir=\${prefix}/lib/frr \
      --libdir=\${prefix}/lib/frr \
      --libexecdir=\${prefix}/lib/frr \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --with-moduledir=\${prefix}/lib/frr/modules \
      --enable-configfile-mask=0640 \
      --enable-logfile-mask=0640 \
      --enable-snmp=agentx \
      --enable-multipath=64 \
      --enable-user=frr \
      --enable-group=frr \
      --enable-vty-group=frrvty \
      --with-pkg-git-version \
      --with-pkg-extra-version=-MyOwnFRRVersion && \
        make && \
        make install

RUN install -m 775 -o frr -g frr -d /var/log/frr
RUN install -m 775 -o frr -g frrvty -d /etc/frr
RUN install -m 640 -o frr -g frrvty frr/tools/etc/frr/vtysh.conf /etc/frr/vtysh.conf
RUN install -m 640 -o frr -g frr frr/tools/etc/frr/frr.conf /etc/frr/frr.conf
RUN install -m 640 -o frr -g frr frr/tools/etc/frr/daemons.conf /etc/frr/daemons.conf
RUN install -m 640 -o frr -g frr frr/tools/etc/frr/daemons /etc/frr/daemons

RUN install -m 644 frr/tools/frr.service /etc/systemd/system/frr.service

RUN apt-get install -y systemctl

RUN systemctl enable frr
RUN systemctl start frr

CMD ["FRR Docker build successfully"]
