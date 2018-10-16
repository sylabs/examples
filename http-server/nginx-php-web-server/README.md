# Nginx

In this example, we will run a simple nginx php server in a container.

We are installing Nginx on a Ubuntu container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
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

Or you can build from a definition file, click [here](#building-from-a-definition-file) or scroll down.

<br>


Now we need to prepair are directory for the Nginx container:

```
$ mkdir -p nginx/{body,fastcgi,log,proxy,run,scgi,sites-available,tmp,uwsgi,www/html}
```
```
$ touch nginx/{favicon.ico,tmp/data.txt,log/{access.log,error.log},run/nginx.pid}
```

And prepain for PHP:

```
$ mkdir -p php/{log}
```

```
$ touch php/{log/php7.0-fpm.log,php7.0-fpm.pid,php7.0-fpm.sock,php.ini}
```

<br>

### Create the PHP file:

There are two PHP file in this repo,<br>
We will first test the `index.php` file.

The PHP file will be in `nginx/www/html/index.php`.

```
$ nano nginx/www/html/index.php
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
$ wget -O nginx/www/html/index.php https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/index.php
```

<br>

### Almost ready to run it,

There are a lot of bind points, so its helpfulll to have a start script.

We will make a start instance script, but you can also shell into the container insted.

```
$ nano start.sh
```
```
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
 -B php/php.ini:/etc/php/7.0/fpm/php.ini \
 -B php/:/run/php \
 -B php/log/php7.0-fpm.log:/var/log/php7.0-fpm.log \
 -B nginx/tmp/data.txt:/tmp/data.txt \
 nginx.sif nginx php
```

Again, you can just download it:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/start.sh
```

<br>

Change the permission so we can run it:

```
$ chmod +x start.sh
```

<br>

Finely, you can start the instance:

```
$ sudo ./start.sh
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

INFO:    instance started successfully
```

<br>

Then open you browser to: http://localhost/index.php,<br>
Or: http://<YOUR_IP_ADDRESS>/index.php


Or you can use `w3m`:

```
$ w3m localhost/index.php
# or
$ w3m <YOUR_IP_ADDRESS>/index.php
```
And you should see you web page.

<br>
<br>

### Running the test form:

Now we will run a simple PHP test form thats in this repo.

The PHP file will access a file called `data.txt`,<br>
That file will be in `nginx/tmp/data.txt`.

<br>

To start, replace the hello world `index.php` with the PHP form:

```
$ rm nginx/www/html/index.php
$ wget -O nginx/www/html/index.php https://github.com/sylabs/examples/blob/master/http-server/nginx-php-web-server/index.php
```

<br>

Then, make the `data.txt` file:

```
$ touch nginx/tmp/data.txt
```



<br>
<br>










### Building from a definition file

First, we need the definition file, you can copy-paste it to `nginx.def`:

```
$ nano nginx.def
```
```
Bootstrap: library
From: ubuntu:16.04


%startscript
nginx -t
service php7.0-fpm stop
service php7.0-fpm start
service nginx stop
service nginx start


%post
apt-get -y update
apt-get -y install nginx
apt-get -y install php-fpm php-mysql

cat << EOF > /etc/nginx/sites-available/default 

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
        	fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    	}

	    location ~ /\.ht {
    	    deny all;
    	}

}

EOF


```

Or just download it from Github:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/http-server/nginx-php-web-server/nginx.def
```

<br>

Now to build the container:

```
$ sudo singularity build nginx.sif nginx.def
```

<br>







<br>
<br>

