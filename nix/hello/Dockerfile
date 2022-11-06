# syntax=docker/dockerfile:1
FROM alpine
COPY --link nix/store/2hmdbfccrmh7a390k8ypqgivp4rjcnc4-libidn2-2.3.2/ /nix/store/2hmdbfccrmh7a390k8ypqgivp4rjcnc4-libidn2-2.3.2//
COPY --link nix/store/in020k27gzbbn56r39hqbmdyhl2l11wr-hello-0.0.1/ /nix/store/in020k27gzbbn56r39hqbmdyhl2l11wr-hello-0.0.1//
COPY --link nix/store/ynn1by1qdl16q6qwwh2h7zkgrn36c6i8-glibc-2.35-163/ /nix/store/ynn1by1qdl16q6qwwh2h7zkgrn36c6i8-glibc-2.35-163//
COPY --link nix/store/z3wzds48bkfkn05qwc90294p14hflr6n-libunistring-1.0/ /nix/store/z3wzds48bkfkn05qwc90294p14hflr6n-libunistring-1.0//
ENTRYPOINT [ "/bin/sh" ]
ENV PATH /nix/store/2hmdbfccrmh7a390k8ypqgivp4rjcnc4-libidn2-2.3.2//bin:/nix/store/in020k27gzbbn56r39hqbmdyhl2l11wr-hello-0.0.1//bin:/nix/store/ynn1by1qdl16q6qwwh2h7zkgrn36c6i8-glibc-2.35-163//bin:/nix/store/z3wzds48bkfkn05qwc90294p14hflr6n-libunistring-1.0//bin:/bin
