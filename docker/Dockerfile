#
# Dynamic Software Update Dockerfile
#

# Pull base image
FROM samirabloom/docker-go

# Maintainer details
MAINTAINER Samira Rabbanian "samira.rabanian@gmail.com"

# Setup correct GOPATH
ENV GOPATH /home/goworld

# install dependencies
RUN go get code.google.com/p/go-uuid/uuid && \
    go get github.com/op/go-logging && \
    go get github.com/samirabloom/doxy

VOLUME /config

# define default command
CMD ["doxy", "-logLevel", "INFO", "-configFile", "/config/config.json"]