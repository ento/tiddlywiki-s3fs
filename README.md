# TiddlyWiki on s3fs

## Docker image

- base image: node
- launches s3fs and tiddlywiki through supervisor

## Terraform configuration

Configuration for running all of the below on Amazon ECS.

```
Container tiddlywiki : Server 80 with LetsEncryptConfig

Container letsencrypt-companion : Maybe LetsEncryptConfig -> Maybe Cert

Container docker-gen-with-tpl : Maybe Cert -> nginx.conf that proxies to tiddlywiki

Container nginx : nginx.conf -> Server 80/443

Sub docker-gen
  |> map letsencrypt-companion

Sub docker-gen
  |> map docker-gen-with-tpl
```

Cert and config files are shared through volumes.
