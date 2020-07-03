FROM ubuntu:focal
MAINTAINER admin <hello@admin.com>


# Install necessary packages
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
	&& apt-get update  \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    make \
    wget \
    bzip2 \
    git \
    curl \
    build-essential \
    xvfb \
    arduino \
    libgtk2.0 \
    libjssc-java \
  && rm -rf /var/lib/apt/lists/*
  
  
