FROM gitpod/workspace-full

# Install V
WORKDIR $HOME/v
RUN sudo chown -R gitpod: .
RUN git clone https://github.com/vlang/v . && make
RUN sudo ./v symlink

# install openssl
RUN sudo apt-get update \
    && sudo apt-get install -y \
        libssl-dev \
    && sudo rm -rf /var/lib/apt/lists/*
# check v
RUN v self

WORKDIR $HOME