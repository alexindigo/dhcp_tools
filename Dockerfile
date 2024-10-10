FROM debian:bookworm AS build

ENV DEBIAN_FRONTEND=noninteractive

# Dev essential dependencies
RUN apt update
RUN apt install -y build-essential wget
RUN wget https://downloads.dlang.org/pre-releases/2.x/2.110.0/dmd_2.110.0~beta.1-0_amd64.deb && \
    apt install -y ./dmd_2.110.0~beta.1-0_amd64.deb && \
    rm ./dmd_2.110.0~beta.1-0_amd64.deb

COPY dhcptest /dhcptest

# Keeping it separate layers
RUN dmd --version
RUN cd /dhcptest && \
    dmd dhcptest.d && \
    ./dhcptest --help

FROM debian:bookworm-slim
LABEL maintainer="Alex Indigo <iam@alexindigo.com>"

ENV PATH="$PATH:/usr/bin/"

COPY --from=build /dhcptest/dhcptest /usr/bin/

RUN dhcptest --help

CMD [ "/usr/bin/dhcptest" ]
