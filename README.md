# Tiddlywiki on s3fs

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

## Deploying the image with AWS ECS (old)

- Create an S3 bucket to backup your tiddlers
  - Create an IAM access key that can read/write to the S3 bucket
  - Upload a tiddlywiki folder to the bucket
    - A tiddlywiki folder is something created by the `tiddlywiki --init` command
- Upload an SSL server certificate (won't work without one)
- Create VPC resources using `vpc.template`
- Create an ECS cluster
- Create EC2 resources using `ec2.template`
- Create a task definition in ECS
  - image: ento/tiddlywiki-s3fs:0.1.0
  - privileged: true
  - set up environment variables as listed in `run.sh`
  - host/container port: 80
- Create a service within your ECS cluster
