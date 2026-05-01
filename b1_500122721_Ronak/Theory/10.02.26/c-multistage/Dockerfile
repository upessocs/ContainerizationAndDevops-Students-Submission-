# Stage 1: Build Stage
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y gcc
COPY hello.c .
RUN gcc -static -o hello hello.c

# Stage 2: Runtime Stage

FROM scratch
COPY --from=builder /hello /hello
CMD ["/hello"]