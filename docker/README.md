## Doxy Dockerfile

This repository contains a **Dockerfile** to create the Doxy Docker proxy

This **Dockerfile** has been published as a [trusted build](https://index.docker.io/u/samirabloom/doxy/) to the public [Docker Registry](https://index.docker.io/).


### Dependencies

* [samirabloom/docker-go](https://registry.hub.docker.com/u/samirabloom/docker-go/)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/samirabloom/doxy/) from public [Docker Registry](https://index.docker.io/): `docker pull samirabloom/doxy`

   (alternatively, you can build an image from Dockerfile: `docker build -t="samirabloom/doxy" github.com/samirabloom/doxy`)


### Usage

```bash
docker run -i -t -name doxy -rm -v `pwd`/config:/config samirabloom/doxy
```

### What is Doxy

1. Seamless dynamic software upgrade using four different upgrade mechanisms:
 1. Instant upgrade - immediate upgrade to the latest version of an application
 1. Session upgrade - upgrading only new sessions to the latest version of an application
 1. Gradual upgrade - gradual upgrade of clients to the latest version of an application
 1. Concurrent upgrade - routing requests to multiple versions of an application simultaneously and returning the response from the latest version of the application that is behaving correctly
1. Automatic rollback when an upgraded version does not behave correctly.
1. Two mechanisms to manage software versions:
 1. Distinct TCP sockets for each version of an application.  The proxy is configured to communicate with each application version on a separate IP and port combination.
 1. Distinct Docker images for each version of an application.  The proxy manages a Docker container based on each application version using a different image or image tag.
1. Two mechanisms to configure the proxy:
 1. File base API in JSON format which is parsed when the proxy loads. All features of the TCP based application version configuration and Docker image based configuration are supported.
 1. A REST API in JSON / HTTP format which can be used to query, add or remove application versions.  All features of the TCP based application version configuration and Docker image based configuration are supported.
    
[Samira Bloom](https://github.com/samirabloom)