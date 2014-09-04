# example instant upgrades
curl -v -X PUT 'http://127.0.0.1:9090/configuration/cluster' -H 'Content-Type: application/json' -d @config_for_curl/config_curl_docker.json
curl -v -X PUT 'http://127.0.0.1:9090/configuration/cluster' -H 'Content-Type: application/json' -d @config_for_curl/config_curl_docker_coachbase.json
curl -v -X PUT 'http://127.0.0.1:9090/configuration/cluster' -H 'Content-Type: application/json' -d @config_for_curl/config_curl_docker_wordpress_INSTANT.json

# example session upgrade
curl -v -X PUT 'http://127.0.0.1:9090/configuration/cluster' -H 'Content-Type: application/json' -d @config_for_curl/config_curl_docker_wordpress_SESSION.json

# example concurrent upgrade
curl -v -X PUT 'http://127.0.0.1:9090/configuration/cluster' -H 'Content-Type: application/json' -d @config_for_curl/config_curl_upgrade_CONCURRENT.json

# example list configurations
curl -v -X GET 'http://127.0.0.1:9090/configuration/cluster/'

# example delete configuration
curl -v -X DELETE 'http://127.0.0.1:9090/configuration/cluster/48c2a4e6-31ba-11e4-bcdb-28cfe9158b63'