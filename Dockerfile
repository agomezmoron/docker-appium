FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <agommor@gmail.com>

#==========================
# Build arguments
#==========================

ARG ANDROID_SDK_VERSION=23
ARG JAVA_VERSION=8
ARG APPIUM_VERSION=1.5.2
ARG ANDROID_HOME=/opt/android-sdk-linux
ARG APPIUM_HOME=/opt/appium
ARG VNC_PASSWD=1234

#==========================
# Env variables
#==========================

ENV VNC_PASSWD ${VNC_PASSWD}
ENV DEBIAN_FRONTEND noninteractive
ENV ANDROID_SDK_VERSION ${ANDROID_SDK_VERSION}
ENV ANDROID_SDKTOOLS_VERSION 24.4.1
ENV JAVA_VERSION ${JAVA_VERSION}
ENV APPIUM_VERSION ${APPIUM_VERSION}
ENV ANDROID_HOME ${ANDROID_HOME}
ENV APPIUM_HOME ${APPIUM_HOME}
ENV SDK_PACKAGES \
platform-tools,\
build-tools-23.0.3,\
build-tools-23.0.2,\
build-tools-23.0.1,\
build-tools-22.0.1,\
android-23,\
android-22,\
sys-img-armeabi-v7a-android-$ANDROID_SDK_VERSION,\
sys-img-x86_64-android-$ANDROID_SDK_VERSION,\
sys-img-x86-android-$ANDROID_SDK_VERSION,\
sys-img-armeabi-v7a-google_apis-$ANDROID_SDK_VERSION,\
sys-img-x86_64-google_apis-$ANDROID_SDK_VERSION,\
sys-img-x86-google_apis-$ANDROID_SDK_VERSION,\
addon-google_apis-google-$ANDROID_SDK_VERSION,\
source-$ANDROID_SDK_VERSION,extra-android-m2repository,\
extra-android-support,\
extra-google-google_play_services,\
extra-google-m2repository

#==========================
# Install Android SDK's and Platform tools, among with other necessary packages
#==========================

ADD assets/etc/apt/apt.conf.d/99norecommends /etc/apt/apt.conf.d/99norecommends
ADD assets/etc/apt/sources.list /etc/apt/sources.list

RUN apt-get update -y \
  && apt-get install -y software-properties-common python-software-properties \
  && add-apt-repository ppa:openjdk-r/ppa -y \
  && apt-get update -y \
  && apt-get -y --no-install-recommends install \
    xvfb \
    x11vnc \
    libvirt-bin \
    qemu-kvm \
    libxi6 \
    libgconf-2-4 \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    maven \
    wget \
    curl \
    unzip \
    openjdk-${JAVA_VERSION}-jdk \
  && wget --progress=dot:giga -O /opt/android-sdk-linux.tgz \
    https://dl.google.com/android/android-sdk_r$ANDROID_SDKTOOLS_VERSION-linux.tgz \
  && tar xzf /opt/android-sdk-linux.tgz -C /tmp \
  && rm /opt/android-sdk-linux.tgz \
  && mv /tmp/android-sdk-linux $ANDROID_HOME \
  && apt-get -qqy clean && rm -rf /var/cache/apt/*
  
RUN echo 'y' | $ANDROID_HOME/tools/android update sdk -s -u -a -t ${SDK_PACKAGES} \
  && echo 'y' | $ANDROID_HOME/tools/android update sdk -s -u -a -t tools \
  && mv $ANDROID_HOME/temp/tools_*.zip $ANDROID_HOME/tools.zip \
  && unzip $ANDROID_HOME/tools.zip -d $ANDROID_HOME/ \
  && rm -rf $ANDROID_HOME/extras/android/m2repository \
  && echo 'y' | $ANDROID_HOME/tools/android update sdk --no-ui

ENV PATH $PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools

#==========================
# X11 Configuration
#==========================

ENV X11_RESOLUTION "800x600x24"
ENV DISPLAY :1
ENV SHELL "/bin/bash"

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

#==========================
# Install Appium
#==========================

RUN mkdir $APPIUM_HOME \
  && cd $APPIUM_HOME \
  && npm install appium@$APPIUM_VERSION \
  && ln -s $APPIUM_HOME/node_modules/.bin/appium /usr/bin/appium \
  && ln -s $ANDROID_HOME/platform-tools/adb /usr/local/sbin/adb
  
#EXPOSE 4723

COPY ./assets/bin/entrypoint /
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]