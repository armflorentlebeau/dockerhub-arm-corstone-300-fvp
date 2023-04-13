FROM ubuntu:22.04

ARG FVP_MAJ_VER
ARG FVP_MIN_VER
ARG FVP_REV_VER

RUN if ! [ "$(arch)" = "x86_64" ] ; then exit 1; fi

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install wget sudo tar libdbus-1-3 libatomic1 tmux telnet
RUN apt-get clean

ENV USER=ubuntu
RUN useradd --create-home -s /bin/bash -m $USER && echo "$USER:ubuntu" | chpasswd && adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN wget https://developer.arm.com/-/media/Arm%20Developer%20Community/Downloads/OSS/FVP/Corstone-300/FVP_Corstone_SSE-300_${FVP_MAJ_VER}.${FVP_MIN_VER}_${FVP_REV_VER}.tgz
RUN tar xf FVP_Corstone_SSE-300_${FVP_MAJ_VER}.${FVP_MIN_VER}_${FVP_REV_VER}.tgz
RUN mkdir -p /home/ubuntu/FVP
RUN ./FVP_Corstone_SSE-300.sh --i-agree-to-the-contained-eula --no-interactive --destination /home/ubuntu/FVP
RUN chown -R ubuntu:ubuntu /home/ubuntu/FVP
RUN rm -rf FVP_Corstone_SSE-300_${FVP_MAJ_VER}.${FVP_MIN_VER}_${FVP_REV_VER}.tgz FVP_Corstone_SSE-300.sh license_terms

COPY fvp_launch.sh /home/ubuntu/
RUN chown ubuntu:ubuntu /home/ubuntu/fvp_launch.sh
RUN chmod +x /home/ubuntu/fvp_launch.sh

WORKDIR /home/ubuntu
USER ubuntu

ENTRYPOINT ["/home/ubuntu/fvp_launch.sh"]

