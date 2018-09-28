# HTTP Server

In this example, we will run a simple Apache Web server in a container.

<br>

What you need:
 - Singularity, you can download it [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - root access.
 - a browser to test it, you can `w3m`, you can install it by `sudo apt-get install w3m w3m-img`
 

<br>

To start, make the definition file.

`micro httpd.def`

*you can replace `micro` with other text editors*
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

Then to build this container:
```
sudo singularity build httpd.sif httpd.def
```

<br>
We now have a simple container that will run a HTTP server listening on port 8080. Our web content, and logs, are going to be stored from a share on the host. So we create a directory tree on host system:

```
mkdir -p web/{htdocs,logs}
```

<br>

Now are directory map should look like this:

```
web/
|-- htdocs/
|   `-- index.html
`-- logs/
```
<br>
<br>

Then add a basic index.html file to serve:

`micro index.html`

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

To use this structure, we start up an instance binding our host path, into the container:

```
singularity instance start \
 -B web/htdocs:/usr/local/apache2/htdocs \
 -B web/logs:/usr/local/apache2/logs \
 httpd.sif httpd
```

<br>

**FYI:** the above command is the same as:

```
singularity instance start -B web/htdocs:/usr/local/apache2/htdocs -B web/logs:/usr/local/apache2/logs httpd.sif httpd
```

<br>

You can now open a browser to:

http://localhost:8080

Or:
```
w3m http://localhost:8080
```

And access the index.html file being served from the `web/htdocs/` location.

<br>

To stop the server, run this command:

```
kill $(ps aux | grep 'Singularity instance' | awk '{print $2}' | head -1)
```

<br>
<br>
