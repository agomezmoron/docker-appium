# docker-appium
Docker image to run your appium test against a defined Android emulador and SDK

Based on <a href="https://github.com/vbanthia/docker-appium">vbanthia's idea</a> but parametrized and based on <a href="https://hub.docker.com/_/ubuntu/">Docker Ubuntu 14.04</a>.

## Build instructions

Run the Dockerfile with the following command:


```
$ docker build -t amoron/docker-appium . && docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null

```

You can specify the **Java** version and/or the **Android SDK** to use, like this:

```
$ docker build --build-arg JAVA_VERSION=7,ANDROID_SDK_VERSION=22  -t amoron/docker-appium . && docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null

```

You can optionally input the desired **VNC password** when building, for connecting to the GUI later. Default is **'1234'**. Change it like this:

$ docker build --build-arg JAVA_VERSION=7,ANDROID_SDK_VERSION=22,VNC_PASSWD=**whatever**  -t amoron/docker-appium . && docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null

### Notes

Default values are **8** for Java and **23** for Android. Java can accept versions **6**, **7** and **8** and Android should not take versions above **19**, and not higher than **24**.



The second part of the command, **'&& docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null'**, is an optional one that deletes past images of the builds so the PC does not end up with several duplicated images. It can be removed without affecting the build.

## Run instructions

