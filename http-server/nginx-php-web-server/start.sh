#!/bin/bash

singularity instance start \
 -B nginx/log/error.log:/var/log/nginx/error.log \
 -B nginx/run/nginx.pid:/run/nginx.pid \
 -B nginx/log/access.log:/var/log/nginx/access.log \
 -B nginx/:/var/cache/nginx \
 -B nginx/body/:/var/lib/nginx/body \
 -B nginx/proxy/:/var/lib/nginx/proxy \
 -B nginx/fastcgi/:/var/lib/nginx/fastcgi \
 -B nginx/uwsgi/:/var/lib/nginx/uwsgi \
 -B nginx/scgi/:/var/lib/nginx/scgi \
 -B nginx/run/nginx.pid:/var/run/nginx.pid \
 -B nginx/favicon.ico:/usr/share/nginx/html/favicon.ico \
 -B nginx/www/html/index.php:/var/www/html/index.php \
 -B nginx/tmp/data.txt:/tmp/data.txt \
 -B php/php.ini:/etc/php/7.0/fpm/php.ini \
 -B php/:/run/php \
 -B php/log/php7.0-fpm.log:/var/log/php7.0-fpm.log \
 nginx.sif nginx php
