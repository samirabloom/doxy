#
# Dynamic Software Update Dockerfile
#

# Pull base image
FROM samirabloom/docker-go

# Maintainer details
MAINTAINER Samira Rabbanian "samira.rabanian@gmail.com"

# Setup correct GOPATH
ENV GOPATH /home/goworld/src/github.com/samirabloom/doxy:/home/goworld

# install dependencies
RUN go get -v code.google.com/p/go-uuid/uuid && \
    go get -v github.com/op/go-logging && \
	go get -v github.com/fsouza/go-dockerclient && \
	go get -v github.com/franela/goreq && \
    go get -v github.com/samirabloom/doxy && \
    cd /usr/local/go_path/src/github.com/samirabloom/doxy && \
    make

VOLUME /config

# define default command
CMD ["doxy", "-logLevel", "INFO", "-configFile", "/config/config.json"]