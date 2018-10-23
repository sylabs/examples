# Nginx

In this example, we will run a simple Nginx(1.10.X) PHP-7.0 server in a container.

We are installing Nginx on a Ubuntu 16.04 container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - Root access.
 - A browser to test it, or you can use `w3m`, and install it by `sudo apt-get install w3m w3m-img`.


____

<br>

### To start, make the working directory:

```
$ mkdir ~/nginx
$ cd ~/nginx/
```

<br>

Now you can pull the container from the library:

```
$ singularity pull library://sylabs/examples/nginx.sif:latest
```

Or you can build from a definition file. Click [here](#building-from-a-definition-file) or scroll down.

<br>


### Prepare our directory for the Nginx container:

To prepare our directory for Nginx, make the bind points:

```
$ mkdir -p nginx/php
```

<br>

### Create the PHP file:

There are two PHP files in this repo.<br>
We will first test the `index.php` file.

The PHP file will be in `nginx/index.php`.

```
$ nano nginx/index.php
```
```
<!DOCTYPE html>
<html>
<head>
<title>Nginx container test</title>
</head>
<body>
<h1>Hello World</h1>
<?php
echo "hello world from PHP!<br>";
?>
</body>
</html>
```

Or you can download it with `wget`:

```
$ wget -O nginx/index.php https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/index.php
```

<br>

### Running the container:

To start the instance:

```
$ sudo singularity instance start -B nginx/:/srv/nginx/ -B nginx/php/:/run/php/ nginx.sif nginx
```
*The `sudo` is important.*

If theres no errors, its working correctly.


<br>

### Testing it:

To test it, open you browser to: http://localhost/index.php,<br>
or: http://<YOUR_IP_ADDRESS>/index.php

You can also use `w3m`:

```
$ w3m localhost/index.php
# or
$ w3m <YOUR_IP_ADDRESS>/index.php
```
And you should see your web page.

<br>
<br>

### Running the test form:

Now we will run a simple PHP test form that's in this repo.

The PHP file will access a file called `data.txt`.<br>
That file will be in `nginx/tmp/data.txt`.

<br>

To start, replace the hello world `index.php` with the PHP form:

```
$ rm nginx/www/html/index.php
$ wget -O nginx/www/html/index.php https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/form_index.php
```

<br>

We already created `nginx/tmp/data.txt`, and the bind points are already set up in our start script.

<br>

Finally, restart the instance:

```
$ sudo singularity instance stop nginx
# then startup the instance
$ sudo ./start.sh
```

<br>

Now open you browser to: http://localhost/index.php,<br>
or: http://<YOUR_IP_ADDRESS>/index.php

Or with `w3m`:

```
$ w3m localhost/index.php
# or
$ w3m <YOUR_IP_ADDRESS>/index.php
```
And you should see you web form.

<br>

### Stoping the instance:

To stop the instance, we will use the `instance stop` function:

```
$ sudo singularity instance list
[...]
$ sudo singularity instance stop nginx
```

<br>
<br>


### Building from a definition file:

First, we need the definition file, which you can copy-paste to `nginx.def`:

```
$ nano nginx.def
```
```
Bootstrap: library
From: ubuntu:16.04

%help
Nginx 1.10.3 web server in a Ubuntu 16.04 container.

Usage:

  instance start:
  $ sudo singularity instance start -B nginx/:/srv/nginx/ -B nginx/php/:/run/php/ nginx.sif

  or to shell:
  $ sudo singularity shell -B nginx/:/srv/nginx/ -B nginx/php/:/run/php/ nginx.sif


%startscript
nginx -t
/etc/init.d/php7.0-fpm restart
/etc/init.d/nginx restart


%post
apt-get -y update
apt-get -y install nginx
apt-get -y install php-fpm php-mysql

echo "=> creating nginx directory: /srv/nginx/"

mkdir /srv/nginx
#mkdir /srv/nginx/php

#mkdir /run/php

touch /srv/nginx/error.log
touch /srv/nginx/access.log
touch /srv/nginx/index.php
touch /srv/nginx/php7.0-fpm.log
touch /srv/nginx/php7.0-fpm.sock
touch /srv/nginx/php7.0-fpm.log

rm -f /var/log/nginx/error.log
ln -s /srv/nginx/error.log /var/log/nginx/error.log

rm -f /var/log/nginx/access.log
ln -s /srv/nginx/access.log /var/log/nginx/access.log

rm -f /var/www/html/index.php
ln -s /srv/nginx/index.php /var/www/html/index.php

rm -f /var/log/php7.0-fpm.log
ln -s /srv/nginx/php7.0-fpm.log /var/log/php7.0-fpm.log

#ln -s /srv/nginx/php/ /run/php/

#chown www-data:www-data /run/php/

mkdir /var/lib/nginx/body
mkdir /srv/nginx/body
ln -s /var/lib/nginx/body /srv/nginx/body

cat << EOF > /etc/nginx/sites-available/default 
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html/;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
        	#fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        	fastcgi_pass unix:/srv/nginx/php7.0-fpm.sock;
    	}

	    location ~ /\.ht {
    	    deny all;
    	}

}

EOF


cat << EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /srv/nginx/nginx.pid;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	access_log /srv/nginx/access.log;
	error_log /srv/nginx/error.log;

	gzip on;
	gzip_disable "msie6";

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}

EOF


nginx -t


cat << EOF > /etc/php/7.0/fpm/php-fpm.conf 

[global]

pid = /srv/nginx/php7.0-fpm.pid

error_log = /srv/nginx/php7.0-fpm.log

include=/etc/php/7.0/fpm/pool.d/*.conf

EOF

```

Or, just download it from Github:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/nginx.def
```

<br>

Now, build the container:

```
$ sudo singularity build nginx.sif nginx.def
```

Then you should have you container (`nginx.sif`) and you don't need to download it from the library.

Now you can [Prepare our directory for the Nginx container](#prepare-our-directory-for-the-nginx-container).

<br>


____



<br>
<br>

