# Arm Corstone-300 FVP Docker image

A Ubuntu 22.04 image providing the [Arm Corstone-300 Ecosystem FVP](https://community.arm.com/oss-platforms/w/docs/603/corstone-300-platforms) for embedded development on microcontrollers. The Corstone-300 FVP is an accurate model of Arm-based SoCs based on the Cortex-M55 processor, the Ethos-U55 and the Ethos-U65 microNPU.

## How to run microcontroller applications

On a local x86_64 machine, we have built an example application called `hello-world.axf` for Cortex-M55 in our current directory.

If we have installed the Arm Corstone-300 FVP locally, we can run:

```
FVP_Corstone_SSE-300_Ethos-U55 -a hello-world.axf
```

With this Docker image, we can run:

```
docker run --rm -ti -v $PWD/hello-world.axf:/home/ubuntu/hello-world.axf arm-corstone-300-fvp -a hello-world.axf
```

The image will launch the FVP and display the following output:

```
(default) Launching Ethos-U55 version.
telnetterminal0: Listening for serial connection on port 5000
telnetterminal1: Listening for serial connection on port 5001
telnetterminal2: Listening for serial connection on port 5002
telnetterminal5: Listening for serial connection on port 5003

    Ethos-U rev 136b7d75 --- Nov 25 2021 12:05:57
    (C) COPYRIGHT 2019-2021 Arm Limited
    ALL RIGHTS RESERVED
```

Before displaying 4 [tmux](https://github.com/tmux/tmux/wiki) panes in the current terminal. Each pane will launch a Telnet connection to a UART port.

## How to pass additional FVP arguments

If we need to pass more arguments to the FVP, we can just append them to the `docker run` command above.

## How to enable Ethos-U65 instead of Ethos-U55 by default

Set the environment variable ETHOS_U65 to 1. For example:

```
docker run --rm -ti -e ETHOS_U65=1 -v $PWD/hello-world.axf:/home/ubuntu/hello-world.axf arm-corstone-300-fvp -a hello-world.axf
```

This will display the following output:

```
Launching Ethos-U65 version.
telnetterminal0: Listening for serial connection on port 5000
telnetterminal1: Listening for serial connection on port 5001
telnetterminal2: Listening for serial connection on port 5002
telnetterminal5: Listening for serial connection on port 5003

    Ethos-U rev 136b7d75 --- Nov 25 2021 12:05:57
    (C) COPYRIGHT 2019-2021 Arm Limited
    ALL RIGHTS RESERVED
```

## How to enable non-interactive mode

Set the environment variable NON_INTERACTIVE to 1. For example:
```
docker run --rm -ti -e NON_INTERACTIVE=1 -v $PWD/hello-world.axf:/home/ubuntu/hello-world.axf arm-corstone-300-fvp -a hello-world.axf
```

This will display the following output and return:

```
(default) Launching Ethos-U55 version.
Running in non-interactive mode
telnetterminal1: Listening for serial connection on port 5000
telnetterminal2: Listening for serial connection on port 5001
telnetterminal5: Listening for serial connection on port 5002
telnetterminal0: Listening for serial connection on port 5003

    Ethos-U rev 136b7d75 --- Nov 25 2021 12:05:57
    (C) COPYRIGHT 2019-2021 Arm Limited
    ALL RIGHTS RESERVED

Hello world.


Info: /OSCI/SystemC: Simulation stopped by user.
[warning ][main@0][01 ns] Simulation stopped by user
```
