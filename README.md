doxy - Dynamic Upgrade Proxy for Docker
=======================================

## Installation

### 1. Install Go

The Go distribution and the Go tools can be downloaded from (https://golang.org/doc/install)[https://golang.org/doc/install]

### 2. Install Git

Git can be installed from (http://git-scm.com/downloads)[http://git-scm.com/downloads]

### 3. Install Docker

Docker can be installed from (https://docs.docker.com/installation/#installation)[https://docs.docker.com/installation/#installation]

After Docker installation to ensure that the Docker daemon listens on a TCP socket and the proxy can connect to it, the following two commands should be executed:

```bash
sed -i 's/#DOCKER_OPTS.*/DOCKER_OPTS="-H unix:\/\/ -H tcp:\/\/0.0.0.0:2375"/g' /etc/default/docker.io

service docker.io restart
```

### 4. Install Proxy

The proxy can be installed in two simple steps as follows:

```bash
git clone https://github.com/samirabloom/doxy

make
```

The above steps install the proxy to the PATH by adding it to the `/usr/local/bin` directory. However, this will only work if the PATH environment variable has `/usr/local/bin` in its list of directories.

### 5. Run Proxy

The proxy can be run from the command line with the following options:

```bash
Usage of proxy:
  -configFile="./config.json":  Set the location of the configuration file
  that should contain configuration to start the proxy,
  for example:
              {
                  "proxy": {
                      "port": 1235
                  },
                  "configService": {
                      "port": 9090
                  },
                  "dockerHost": {
                      "ip": "127.0.0.1",
                      "port": 2375
                  },
                  "cluster": {
                      "containers":[
                          {
                              "image": "mysql",
                              "tag": "latest",
                              "name": "some-mysql",
                              "environment": [
                                  "MYSQL_ROOT_PASSWORD=mysecretpassword"
                              ],
                              "volumes": [
                                  "/var/lib/mysql:/var/lib/mysql"
                              ]
                          },
                          {
                              "image": "wordpress",
                              "tag": "3.9.1",
                              "portToProxy": 8080,
                              "name": "some-wordpress",
                              "links": [
                                  "some-mysql:mysql"
                              ],
                              "portBindings": {
                                  "80/tcp": [
                                      {
                                          "HostIp": "0.0.0.0",
                                          "HostPort": "8080"
                                      }
                                  ]
                              }
                          }
                      ],
                      "version": "3.9.1"
                  }
              }

  -logLevel="WARN":  Set the log level as "CRITICAL", "ERROR", "WARNING",
  "NOTICE", "INFO" or "DEBUG"

  -h: Displays this message
```

For example the following command will run the proxy in the `INFO` log level and uses a file called `./config.json` for its configuration.

```bash
$ proxy -logLevel=INFO -configFile= "config/config_script.json"
```

# REST API

The proxy provides a simple REST API to support dynamically updating the cluster configuration as follows:

* **PUT /configuration/cluster** - adds a new cluster configuration
* **GET /configuration/cluster/{clusterId}** - gets a single cluster configuration
* **GET /configuration/cluster** - gets all cluster configurations
* **DELETE /configuration/cluster/{clusterId}** - deletes a single cluster configuration

## HTTP Response Codes

* **202 Accepted** - a new cluster entity is successfully added or deleted
* **200 OK** - cluster(s) entity is successfully returned
* **404 Not Found** - cluster id is invalid
* **400 Bad Request** - request syntax is  invalid

## PUT - /configuration/cluster
To add a new cluster make a PUT request to `/configuration/cluster`.

###Request Body

```js
{
  "cluster": {
    "servers": [
      {
        "hostname": "",
        "port": 0
      }
    ],
    "version": "0",
    "upgradeTransition": {
        "mode": ""  // allowed values are "INSTANT", "SESSION", "GRADUAL", "CONCURRENT"
        "sessionTimeout": 0  // only supported for a `mode` value of "SESSION"
        "percentageTransitionPerRequest": 0  // only supported for a `mode` value of "GRADUAL"
      }
    }
}
```

##### cluster.servers

Type: `Array ` Default value: `[]`

This value specifies the list of servers in the cluster

##### cluster.servers[i].ip

Type: `String` Default value: `undefined`

This value specifies the ip address or hostname of a server in the cluster

##### cluster.servers[i].port

Type: `Number` Default value: `undefined`

This value specifies the port of a server in the cluster

##### cluster.version

Type: `String` Default value: `0.0`

This value specifies the cluster version. If no version is specified, the version defaults to `0.0`.  The version value is sorted using a string sort so care must be taken when using multi digit version numbers as `13` will be sorted before `3` to resolve this always use `03` for `3`.

##### cluster.upgradeTransition

Type: `Object` Default value: `{ mode: "INSTANT" }`

This value allows the configuration of the upgrade transition. If no `upgradeTransition` is specified, the upgrade transition mode defaults to `INSTANT`.

##### cluster.upgradeTransition.mode

Type: `String` Default value: `SESSION`

This value specifies the upgrade transition mode and support the following values: `INSTANT`, `SESSION`, `GRADUAL`, `CONCURRENT`. If no `upgradeTransition mode` is specified, the mode defaults to `SESSION`.

##### cluster.upgradeTransition.sessionTimeout

Type: `Number` Default value: `undefined`

This value specifies the timeout period assigned to the `SESSION` transition mode.

##### cluster.upgradeTransition.percentageTransitionPerRequest

Type: `Number` Default value: `undefined`

This value specifies the transition percentage associated with each request in the `GRADUAL` transition mode.

###Response Body

A cluster id is returned representing the new cluster entity that has been added.

###Example

##### Request

For example the following JSON would set up a new cluster with two `servers` and `SESSION` upgrade transition:

```js

{
  "cluster": {
    "servers": [
      {
        "hostname": "127.0.0.1",
        "port": 1036
      },
      {
        "hostname": "127.0.0.1",
        "port": 1038
      }
    ],
    "version": "1.1",
    "upgradeTransition": {
      "mode": "SESSION",
      "sessionTimeout": 60
    }
  }
}
```

To send this request with `Curl` use the following syntax:

```bash
curl http://127.0.0.1:9090/configuration/cluster -X PUT --data '{"cluster": {"servers":[{"hostname": "127.0.0.1", "port": 1036},{"hostname": "127.0.0.1", "port": 1038}],"version": "1.1","upgradeTransition": { "mode": "SESSION", "sessionTimeout": 60 }}}'
```

##### Response

```bash
HTTP/1.1 202 Accepted
Date: Sat, 16 Aug 2014 19:54:21 GMT
Content-Length: 36
Content-Type: text/plain; charset=utf-8

1dcbb083-257f-11e4-bcbc-600308a8245e
```
## GET - /configuration/cluster/{clusterId}

To get a single cluster configuration make a GET request to `/configuration/cluster/{clusterId}`.

### Response Body

```js
{
  "cluster": {
    "servers": [
      {
        "hostname": "",
        "port": 0
      }
    ],
    "upgradeTransition": {
      "mode": ""
      "sessionTimeout": 0  // only returned when `mode` is "SESSION"
      "percentageTransitionPerRequest": 0  // only returned when `mode` is "GRADUAL"
    },
    "uuid": "",
    "version": "0"
  }
}
```

### Example

##### Request

For example the following `curl` request would get the cluster configuration with cluster id `1dcbb083-257f-11e4-bcbc-600308a8245e`:

```bash
curl http://127.0.0.1:9090/configuration/cluster/1dcbb083-257f-11e4-bcbc-600308a8245e -X GET
```
##### Response

```js
{
  "cluster": {
    "servers": [
      {
        "hostname": "127.0.0.1",
        "port": 1036
      },
      {
        "hostname": "127.0.0.1",
        "port": 1038
      }
     ],
    "upgradeTransition": {
        "mode": "SESSION",
        "sessionTimeout": 60
    },
    "uuid": "016ca2cd-2585-11e4-ab5c-600308a8245e",
    "version": "1.1"
  }
}

```

For example the response when using curl is as follows:

```bash
HTTP/1.1 200 OK
Date: Sat, 16 Aug 2014 20:37:42 GMT
Content-Length: 206
Content-Type: text/plain; charset=utf-8

{"cluster":{"servers":[{"hostname":"127.0.0.1","port":1036},{"hostname":"127.0.0.1","port":1038}],"upgradeTransition":{"mode":"SESSION","sessionTimeout":60},"uuid":"016ca2cd-2585-11e4-ab5c-600308a8245e","version":"1.1"}}
```

## GET - /configuration/cluster

To get all the cluster configurations make a GET request with no cluster id `/configuration/cluster/`.

### Response Body

````js

[
  {
    "cluster": {
      "servers": [
        {
          "hostname": "",
          "port": 0
        }
       ],
      "upgradeTransition": {
        "mode": ""
        "sessionTimeout": 0  // only returned when `mode` is "SESSION"
        "percentageTransitionPerRequest": 0  // only returned when `mode` is "GRADUAL"
      },
      "uuid": "",
      "version": "0"
    }
  },
  {
    "cluster": {
      "servers": [
        {
          "hostname": "",
          "port": 0
        },
        {
          "hostname": "",
          "port": 0
        }
       ],
      "upgradeTransition": {
        "mode": "CONCURRENT"
      },
      "uuid": "",
      "version": "0"
    }
  }
]
```

### Example

##### Request

For example the following `curl` request would get a list of all cluster configurations

```bash
curl http://127.0.0.1:9090/configuration/cluster/ -X GET
```
##### Response

```js
[
  {
    "cluster": {
      "servers": [
        {
          "hostname": "127.0.0.1",
          "port": 1036
        },
        {
          "hostname": "127.0.0.1",
          "port": 1038
        }
      ],
      "upgradeTransition": {
        "mode": "SESSION",
        "sessionTimeout": 60
      },
      "uuid": "1f6a0854-2608-11e4-ab79-600308a8245e",
      "version": "1.1"
    }
  },
  {
    "cluster": {
      "servers": [
        {
          "hostname": "127.0.0.1",
          "port": 1037
        },
        {
          "hostname": "127.0.0.1",
          "port": 1039
        }
      ],
      "upgradeTransition": {
        "mode": "CONCURRENT"
      },
      "uuid": "01386f1f-2608-11e4-ab79-600308a8245e",
      "version": "1.1"
    }
  },
  {
    "cluster": {
      "servers": [
        {
          "hostname": "127.0.0.1",
          "port": 1034
        },
        {
          "hostname": "127.0.0.1",
          "port": 1035
        }
      ],
      "upgradeTransition": {
        "mode": "INSTANT"
      },
      "uuid": "ffde36ce-2607-11e4-ab79-600308a8245e",
      "version": "1"
    }
  }
]
```

For example the response when using curl is as follows:

```bash
HTTP/1.1 200 OK
Date: Sun, 17 Aug 2014 12:28:55 GMT
Content-Length: 583
Content-Type: text/plain; charset=utf-8

[{"cluster":{"servers":[{"hostname":"127.0.0.1","port":1036},{"hostname":"127.0.0.1","port":1038}],"upgradeTransition":{"mode":"SESSION","sessionTimeout":60},"uuid":"1f6a0854-2608-11e4-ab79-600308a8245e","version":"1.1"}},{"cluster":{"servers":[{"hostname":"127.0.0.1","port":1037},{"hostname":"127.0.0.1","port":1039}],"upgradeTransition":{"mode":"CONCURRENT"},"uuid":"01386f1f-2608-11e4-ab79-600308a8245e","version":"1.1"}},{"cluster":{"servers":[{"hostname":"127.0.0.1","port":1034},{"hostname":"127.0.0.1","port":1035}],"upgradeTransition":{"mode":"INSTANT"},"uuid":"ffde36ce-2607-11e4-ab79-600308a8245e","version":"1"}}]
```

## DELETE - /configuration/cluster/{clusterId}

To delete a single cluster configuration make a DELETE request to `/configuration/cluster/{clusterId}`.

### Example

##### Request

For example the following `curl` request would delete the cluster configuration with id `1dcbb083-257f-11e4-bcbc-600308a8245e`:

```bash
curl http://127.0.0.1:9090/configuration/cluster/1dcbb083-257f-11e4-bcbc-600308a8245e -X DELETE
```
##### Response

For example the response when using curl is as follows:

```bash
HTTP/1.1 202 Accepted
Date: Sat, 16 Aug 2014 21:28:38 GMT
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```