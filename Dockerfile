FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <agommor@gmail.com>

#================================
# Build arguments
#================================

ARG ANDROID_SDK_VERSION=24.3.4
ARG ANDROID_SDK_TOOLS_VERSION=23.0.1
ARG JAVA_VERSION=8
ARG APPIUM_VERSION=1.5.2
ARG ANDROID_HOME=/opt/android-sdk-linux
ARG APPIUM_HOME=/opt/appium

#================================
# Env variables
#================================

ENV DEBIAN_FRONTEND noninteractive
ENV ANDROID_SDK_VERSION ${ANDROID_SDK_VERSION}
ENV ANDROID_SDK_TOOLS_VERSION ${ANDROID_SDK_TOOLS_VERSION}
ENV JAVA_VERSION ${JAVA_VERSION}
ENV APPIUM_VERSION ${APPIUM_VERSION}
ENV ANDROID_HOME ${ANDROID_HOME}
ENV APPIUM_HOME ${APPIUM_HOME}

#================================
# Install Android SDK's and Platform tools
#================================

RUN dpkg --add-architecture i386 \
  && apt-get update -y \
  && apt-get -y --no-install-recommends install \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    wget \
    curl \
    unzip \
    openjdk-${JAVA_VERSION}-jdk \
  && wget --progress=dot:giga -O /opt/android-sdk-linux.tgz \
    https://dl.google.com/android/android-sdk_r$ANDROID_SDK_VERSION-linux.tgz \
  && tar xzf /opt/android-sdk-linux.tgz -C /tmp \
  && rm /opt/android-sdk-linux.tgz \
  && mv /tmp/android-sdk-linux $ANDROID_HOME \
  && echo y | $ANDROID_HOME/tools/android update sdk --all --filter platform-tools,build-tools-$ANDROID_SDK_TOOLS_VERSION --no-ui --force \
  && apt-get -qqy clean \
  && rm -rf /var/cache/apt/*

ENV PATH $PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools

#==========================
# Install Appium Dependencies
#==========================

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - \
  && apt-get -qqy install \
    nodejs \
    python \
    make \
    build-essential \
    g++

#=====================
# Install Appium
#=====================

RUN mkdir $APPIUM_HOME \
  && cd APPIUM_HOME \
  && npm install appium@$APPIUM_VERSION \
  && ln -s APPIUM_HOME/node_modules/.bin/appium /usr/bin/appium

EXPOSE 4723

#==========================
# Run appium as default
#==========================
CMD /usr/bin/appium