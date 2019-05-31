# Build docker image with:
# $ docker build -t lpcpsys:latest .
#
# Run (and remove image once finished) with:
# $ docker run --rm -ti lpcpsys:latest

FROM debian:stable-slim
ADD scripts /scripts
RUN sh /scripts/build.sh

# Base command for container
CMD ["/bin/bash"]


