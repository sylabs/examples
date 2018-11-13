# HTTP Server

In this example, we will run a simple Apache Web server in a Singularity Container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A browser to test it, or you can use `w3m`, and install it by `sudo apt-get install w3m w3m-img`.


____

<br>

### Setup:

First, make the working directory:

```
$ mkdir ~/httpd
$ cd ~/httpd/
```

<br>

Then, pull the container from the library:

```
$ singularity pull library://sylabs/examples/httpd:latest
```
If you're running on `32 bit` os, you will need to build from a definition file, click [here](#building-the-container-from-a-definition-file) or scroll down for instructions.

<br>

Now, rename the container you just pulled:

```
$ mv httpd_latest.sif httpd.sif
```

<br>

### Verify the container: (Optional)

```
$ singularity verify httpd.sif
Verifying image: httpd.sif
Data integrity checked, authentic and signed by:
        Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```

<br>

We now have a simple container that will run a HTTP server listening on port 8080.

### Getting help from the container:

To get the help output, we can use the `run-help` command:

```
$ singularity run-help httpd.sif
```
Or, for this specific container, you can just run it:
```
$ ./httpd.sif
```

<br>

## Prepare our directory for the container:

Our web content, and logs, are going to be stored from a share on the host. So, we will create a directory tree on the host system:

To create the directory tree:

```
$ mkdir -p httpd/{htdocs,logs}
```

<br>

Then, add a basic [`index.html`](https://raw.githubusercontent.com/sylabs/examples/master/http-server/apache2-web-server/index.html) file to serve:

```
$ nano httpd/htdocs/index.html
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

Or download it from this repo:

```
$ wget -O httpd/htdocs/index.html https://raw.githubusercontent.com/sylabs/examples/master/http-server/apache2-web-server/index.html
```

<br>

Now our directory map should look like this:

```
~/httpd/
 |-- htdocs/
 |   `-- index.html
 `-- logs/
```

<br>

## Start the instance:

To use this structure, we start up an instance binding our host path into the container:

```
$ singularity instance start -B httpd/:/srv/httpd/ httpd.sif httpd
```

<br>

Finally, open a browser to:

http://localhost:8080

Or:
```
$ w3m http://localhost:8080
```

<br>

Remember, you must open the web page on the same host that is running the instance.

Then access the `index.html` file being served from `httpd/htdocs/` directory.

<br>

## Stopping the instance:

To stop the instance, run this command:

```
$ singularity instance stop httpd
```


<br>
<br>


## Building the container from a definition file:

To build the container from a recipe, you will need root access, and the definition file.

First, download the [definition file](https://raw.githubusercontent.com/WestleyK/examples/master/http-server/apache2-web-server/httpd.def):

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/http-server/apache2-web-server/httpd.def
```

<br>

Then to build the container:

```
$ sudo singularity build httpd.sif httpd.def
```

<br>

If you do not have root access, you can use our remote builder:

```
$ singularity build --remote httpd.sif httpd.def
```

<br>

Now you can [Prepare our directory for the container](#prepare-our-directory-for-the-container).

<br>


____


<br>

