# TiddlyWiki on s3fs

## Architecture

```
app : server:80

letsencrypt-companion : maybe app -> maybe cert

nginx-gen : maybe app -> maybe cert -> nginx.conf

nginx : nginx.conf -> server:80/443
-- no ELB

signal docker-gen
  |> map letsencrypt-companion

signal docker-gen
  |> map nginx-gen
```

Cert and config files are shared through volumes.


## Docker image

- base image: node
- launches s3fs and tiddlywiki through supervisor
