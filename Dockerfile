FROM ubuntu:18.04

USER root 
RUN apt-get update && apt-get install -y sudo sshfs bsdutils python3-dev python-pip \
    libpq-dev pkg-config zlib1g-dev libtool libtool-bin wget automake autoconf coreutils bison libacl1-dev \
    llvm clang \
    build-essential git \
    libffi-dev cmake libreadline-dev libtool 


# ----- mahaloz stuff ----- #
USER root
RUN apt-get update && apt-get install -y \
    tmux \
    xclip \
    vim

# ----- target ----- #
# get source
RUN git clone https://github.com/mahaloz/fmt.git && \
    cd fmt && \
    cmake . && \
    make -j3 && \
    make install 

# compile fuzz target
RUN cd /fmt/test/fuzzing && \
    mkdir build && cd build && \
    export CXX=clang++ && \
    export CXXFLAGS="-fsanitize=fuzzer-no-link -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION= -g" && \
    cmake .. -DFMT_SAFE_DURATION_CAST=On -DFMT_FUZZ=On -DFMT_FUZZ_LINKMAIN=Off -DFMT_FUZZ_LDFLAGS="-fsanitize=fuzzer" && \
    cmake --build . && \
    cp two-args-fuzzer /fuzzme 



    


