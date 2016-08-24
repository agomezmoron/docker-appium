# docker-appium
Docker image to run your appium test against a defined Android emulador and SDK

Based on <a href="https://github.com/vbanthia/docker-appium">vbanthia's idea</a> but parametrized and based on <a href="https://hub.docker.com/_/ubuntu/">Docker Ubuntu 14.04</a>.

## Build instructions

Run the Dockerfile with the following command:

```
$ docker build -t amoron/docker-appium . && docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null
```

### Optional arguments

You can specify the **Java** version, the **Android SDK** or the **VNC password** to use with the following variables (the values used are the default ones):

```
JAVA_VERSION=8
ANDROID_SDK_VERSION=23
VNC_PASSWD=1234
```

Usage:
```
$ docker build --build-arg JAVA_VERSION=8,ANDROID_SDK_VERSION=23,VNC_PASSWD=1234  -t amoron/docker-appium . && docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null
```

### Possible inputs

**Java**:
- 6
- 7
- 8

**Android SDK**:
- 19
- 20
- 21
- 22
- 23
- 24

### Notes

The second part of the command, **'&& docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null'**, is an optional one that deletes past images of the builds so the PC does not end up with several duplicated images. It can be removed without affecting the build.

## Run instructions

Run the image with the following command:

```
docker run --privileged -t -i --net=host amoron/docker-appium
```

### Command specific arguments

- **--privileged**: Allow docker to use the host's virtualization technology (KVM)
- **--net=host**: Connect the container to our local network, so we can easily access it with localhost

### Optional arguments

The run command will create an Android emulator before launching it. You can specify its CPU and device with the following variables (the values used are the default ones):

```
DEVICE="Nexus S"
ABI="default/x86_64"
```

Usage:
```
docker run --privileged -e DEVICE="Nexus S" -e ABI="default/x86_64" -t -i --net=host amoron/docker-appium
```

### Possible inputs

**ABIs (CPUs)**:
- armeabi-v7a
- default/x86
- default/x86_64

**Devices**: 
- tv_1080p
- tv_720p
- wear_round
- wear_round_chin_320_290
- wear_square
- Galaxy Nexus
- Nexus 10
- Nexus 4
- Nexus 5
- Nexus 6
- Nexus 7 2013
- Nexus 7
- Nexus 9
- Nexus One
- Nexus S
- 2.7in QVGA
- 2.7in QVGA slider
- 3.2in HVGA slider (ADP1)
- 3.2in QVGA (ADP2)
- 3.3in WQVGA
- 3.4in WQVGA
- 3.7 FWVGA slider
- 3.7in WVGA (Nexus One)
- 4in WVGA (Nexus S)
- 4.65in 720p (Galaxy Nexus)
- 4.7in WXGA
- 5.1in WVGA
- 5.4in FWVGA
- 7in WSVGA (Tablet)
- 10.1in WXGA (Tablet)


## VNC connection

Open **Remmina**, a built-in app in Ubuntu. Configure a new connection like this:

- **Name**: Whatever you like

- **Protocol**: VNC - Virtual Network Computing

- **Server**: localhost

- **Password**: Your chosen VNC password. If none was given in the build, use '1234'.

Click on '**Connect**' -or '**Save**' if you want to store the connection for further uses- and you should be able to see the emulator, as long as the image is up and running.

## Troubleshooting

### Errors on the build or run step

You can try first stopping the images:

```
$ docker stop $(docker ps -a -q)
```

then deleting them with docker rmi -f <image_id>. You can check the images ids by running:

```
$ docker images
```

### Errors on the VNC connection

You can try first stopping the images:

```
$ docker stop $(docker ps -a -q)
```

then running the image again and reconnecting.
