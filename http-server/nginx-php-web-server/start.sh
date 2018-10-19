#!/bin/bash

singularity instance start \
 -B nginx/log/error.log:/var/log/nginx/error.log \
 -B nginx/log/access.log:/var/log/nginx/access.log \
 -B nginx/run/nginx.pid:/run/nginx.pid \
 -B nginx/lib/:/var/lib/nginx/ \
 -B nginx/favicon.ico:/usr/share/nginx/html/favicon.ico \
 -B nginx/www/html/index.php:/var/www/html/index.php \
 -B nginx/tmp/data.txt:/tmp/data.txt \
 -B php/php.ini:/etc/php/7.0/fpm/php.ini \
 -B php/:/run/php \
 -B php/log/php7.0-fpm.log:/var/log/php7.0-fpm.log \
 nginx.sif nginx php
