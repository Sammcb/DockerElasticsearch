# DockerElasticsearch

When using in a `docker-compose.yml` file, use the following settings:

```
environment:
  - ADMIN_USER=<Elastic superuser name>
  - ADMIN_PASSWORD=<Elastic superuser password>
```

Also make sure packetbeat is connected to the [logstash, kibana] network and the heartbeat network with the alias `elasticsearch`.
