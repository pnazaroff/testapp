# Multistage docker

#Build

FROM gcc:latest as build

WORKDIR /gtest_build

RUN apt-get update && \
    apt-get install -y \
      libboost-dev libboost-program-options-dev \
      libgtest-dev \
      cmake \
    && \
    cmake -DCMAKE_BUILD_TYPE=Release /usr/src/gtest && \
    cmake --build . && \
    mv lib*.a /usr/lib

ADD ./src /app/src

WORKDIR /app/build

RUN cmake ../src && \
    cmake --build . && \
    CTEST_OUTPUT_ON_FAILURE=TRUE cmake --build . --target test


# Deploy
FROM ubuntu:latest

RUN groupadd -r sample && useradd -r -g sample sample
USER sample

WORKDIR /app

COPY --from=build /app/build/hello_world_app .

ENTRYPOINT ["./hello_world_app"]
