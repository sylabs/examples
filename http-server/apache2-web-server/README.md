# HTTP Server

In this example, we will run a simple Apache Web server in a Singularity Container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A browser to test it, or you can use `w3m`, and install it by `sudo apt-get install w3m w3m-img`.
 

<br>

#### To start, make the working directory:

```
$ mkdir httpd
$ cd httpd/
```

<br>

#### Then, pull the container from the library:

```
$ singularity pull library://sylabs/examples/httpd.sif:latest
```

If you're building the container from a recipe, click [here](#building-the-contianer-from-a-recipe) or scroll down.

<br>

#### Now, Rename the container you just pulled:

```
$ mv httpd.sif_latest.sif httpd.sif
```

<br>

We now have a simple container that will run a HTTP server listening on port 8080.

Our web content, and logs, are going to be stored from a share on the host. So, we will create a directory tree on the host system:

#### To create the directory tree:
```
$ mkdir -p web/{htdocs,logs}
```

<br>
<br>

Now our directory map should look like this:

```
web/
|-- htdocs/
|   `-- index.html
`-- logs/
```
<br>
<br>

#### Then add a basic index.html file to serve:

```
$ nano web/htdocs/index.html
```
```
<!DOCTYPE html>
<html>
<head>
<title>Simple Web Page</title>
</head>
<body>

<h1>Simple Web Page From Container</h1>
<h3>cool stuff</h3>

</body>
</html>
```

<br>
<br>

#### To use this structure, we start up an instance binding our host path into the container:

```
$ singularity instance start \
 -B web/htdocs:/usr/local/apache2/htdocs \
 -B web/logs:/usr/local/apache2/logs \
 httpd.sif httpd
```

<br>

*FYI:* the above command is the same as:

```
$ singularity instance start -B web/htdocs:/usr/local/apache2/htdocs -B web/logs:/usr/local/apache2/logs httpd.sif httpd
```

<br>

#### Finally, open a browser to:

http://localhost:8080

Or:
```
$ w3m http://localhost:8080
```

And access the `index.html` file being served from the `web/htdocs/` location.

<br>

#### To stop the server, run this command:

```
$ singularity instance stop httpd
```


<br>
<br>


### Building the contianer from a recipe:

To build the container from a recipe, you will need root access, and the recipe file.

#### First, make the definition file:
```
$ nano httpd.def
```
```
Bootstrap: docker
From: httpd:latest

%post
    # Change the port we are listening on to 8080 instead of 80
    sed -ie "s/^\(Listen\).*/\1 8080/" /usr/local/apache2/conf/httpd.conf

%startscript
    httpd
```
**NOTE:** you can also find the `httpd.def` file in this repo.

<br>

#### Then to build the container:
```
$ sudo singularity build httpd.sif httpd.def
```

Now you should have your container (`httpd.sif`) and you don't need to download it.

<br>
<br>

