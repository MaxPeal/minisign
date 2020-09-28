FROM alpine:latest as build

WORKDIR /usr/src/minisign
RUN apk add --no-cache build-base cmake curl pkgconfig gpgv1
RUN apk add --no-cache upx ||:
RUN apk add --no-cache gnupg1 wget outils-signify busybox-static
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ minisign ||:
RUN curl -fsSL https://download.libsodium.org/libsodium/releases/LATEST.tar.gz && curl -fsSL https://download.libsodium.org/libsodium/releases/LATEST.tar.gz.minisig \
  && minisign -V -P RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3 -m LATEST.tar.gz -x LATEST.tar.gz.minisig && tar xzvf LATEST.tar.gz
RUN cd libsodium-stable && env CFLAGS="-Os" CPPFLAGS="-DED25519_NONDETERMINISTIC=1" ./configure --disable-dependency-tracking 
RUN cd libsodium-stable && env CFLAGS="-Os" CPPFLAGS="-DED25519_NONDETERMINISTIC=1" make -j$(nproc) check 
#RUN cd libsodium-stable && env CFLAGS="-Os" CPPFLAGS="-DED25519_NONDETERMINISTIC=1" make -j"$CPUS" check 
RUN cd libsodium-stable && env CFLAGS="-Os" CPPFLAGS="-DED25519_NONDETERMINISTIC=1" make install 
RUN rm -fr libsodium-stable
#&& cd .. && rm -fr libsodium-stable

COPY ./ ./
RUN mkdir build && cd build && cmake -D BUILD_STATIC_EXECUTABLES=1 .. && make -j$(nproc)
RUN upx --lzma build/minisign ||:

FROM scratch
COPY --from=build /usr/src/minisign/build/minisign /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/minisign"]

# DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]" | sed -e 's/linux\/riscv64,//') --file Dockerfile --tag maxpeal/minisign:foo --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache
