# Makefile for a go project
#
# Author: Samira Rabbanian
# 	
# Targets:
# 	all:          cleans and builds all the code
# 	clean:        cleans the code
#	test:         runs all the tests
#	coverage:     runs all the tests and outputs a coverage report
# 	build:        builds all the code
# 	dependencies: installs dependent projects
# 	install:      installs the code to /usr/local/bin
# 	run:          the doxy with INFO log level

GOBIN := /usr/local/bin/
GOPATH := $(GOPATH):$(shell pwd)
PATH := $(PATH):$(GOPATH)/bin

FLAGS := GOPATH=$(GOPATH)


all: install

clean:
	$(FLAGS) go clean -i -x ./.../$*
	rm -rf $(GOBIN)doxy doxy pkg

test: clean dependencies
	vagrant up docker
	$(FLAGS) go test -v ./.../$*

coverage:
	go get github.com/axw/gocov/gocov
	go get gopkg.in/matm/v1/gocov-html
	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy | PATH=$(PATH):$(GOPATH)/bin gocov-html > proxy_coverage.html
#	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/contexts | PATH=$(PATH):$(GOPATH)/bin gocov-html > contexts_coverage.html
	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/docker_client | PATH=$(PATH):$(GOPATH)/bin gocov-html > docker_client_coverage.html
	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/http | PATH=$(PATH):$(GOPATH)/bin gocov-html > http_coverage.html
#	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/log | PATH=$(PATH):$(GOPATH)/bin gocov-html > log_coverage.html
	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/stages | PATH=$(PATH):$(GOPATH)/bin gocov-html > stages_coverage.html
	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/tcp | PATH=$(PATH):$(GOPATH)/bin gocov-html > tcp_coverage.html
#	PATH=$(PATH):$(GOPATH)/bin $(FLAGS) gocov test -v proxy/transition | PATH=$(PATH):$(GOPATH)/bin gocov-html > transition_coverage.html

dependencies:
	go get -v code.google.com/p/go-uuid/uuid
	go get -v github.com/op/go-logging
	go get -v github.com/fsouza/go-dockerclient
	go get -v github.com/franela/goreq

build: clean dependencies
	$(FLAGS) go build -v -o doxy ./doxy.go

count:
	find . -name "*.go" -print0 | xargs -0 wc -l

install: build
	cp doxy $(GOBIN)

run: install
	doxy -logLevel INFO
