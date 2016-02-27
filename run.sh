#!/bin/sh
docker run -it \
       --rm \
       --cap-add mknod --cap-add sys_admin --device=/dev/fuse \
       -e 'AWSACCESSKEYID=$AWSACCESSKEYID' \
       -e 'AWSSECRETACCESSKEY=$AWSSECRETACCESSKEY' \
       -e 'BUCKET_NAME=$BUCKET_NAME' \
       -e 'WIKI_PATH=$WIKI_PATH' \ # path to wiki folder in the bucket
       -e 'WIKI_USER=$WIKI_USER' \
       -e 'WIKI_PASSWORD=$WIKI_PASSWORD' \
       -p 80:80 \
       ento/tiddlywiki-s3fs:0.1.0
