# Nginx

In this example, we will run a simple nginx php server in a container.

We are installing Nginx on a Ubuntu container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access.
 - A browser to test it, or you can use `w3m`, and install it by `sudo apt-get install w3m w3m-img`.
 
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




















### Building from a definition file

First, we need the definition file, you can copy-paste it to `nginx.def`:

```
$ nano nginx.def
```
```
Bootstrap: library
From: ubuntu:16.04

# i dont know about this part,
%startscript
nginx -t
service php7.0-fpm restart
service nginx restart

%post
apt-get -y update
apt-get -y install nginx
apt-get -y install php-fpm php-mysql
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

