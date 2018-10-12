# Julia

In this example, we will cover:
 - [Pulling a julia container from the library.](#to-start-make-the-working-directory)
 - [Building the container from a definition file.](#to-build-from-a-definition-file)
 - [Running a julia script in a container.](#running-a-julia-script-in-a-container)

<br>

Now of corse you can build the [Official julia container from docker](https://hub.docker.com/_/julia/), <br>
But for this example we will install julia in a [Ubuntu container](https://cloud.sylabs.io/library/library/default/ubuntu). <br>


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A test Julia script, [like this one](#make-the-test-file).
 - Root access (only if you're [building from a definition file](#to-build-from-a-definition-file)).
 


____

<br>


### To start, make the working directory:

```
$ mkdir ~/julia
$ cd ~/julia/
```

<br>

### Make the test file:

We are going to need a Julia script to test it,<br>
So lets make this simple one.

```
$ nano hello-world.jl
```
```
#!/usr/bin/env julia
println("Hello world!")
println("For full tutorial, visit: https://github.com/sylabs/examples/lang/julia")
```

Or just download the test julia file with `wget`:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl
```

<br>
<br>

### Pull the container from the library:


**NOTE:** If your running on 32 bit os, you will need to build from a definition file, click [here](#to-build-from-a-definition-file) or scroll down for instructions.


```
$ singularity pull library://sylabs/examples/julia.sif:latest
```

<br>

Rename the container you pulled:

```
$ mv julia.sif_latest.sif julia.sif
```

<br>


To run the container:

```
$ ./julia.sif 
Hello world!
For full tutorial, visit: https://github.com/sylabs/examples/lang/julia
$ ./julia.sif hello-world.jl
Hello world!
this is comming from your `hello-world.jl` script!
$ 
```

You can also do:

```
$ singularity run julia.sif
```


<br>


### To build from a definition file:

You will need root access to build from a recipe.

First, make the definition file:

```
$ nano julia.def
```
```
BootStrap: library
From: ubuntu:16.04

%runscript
# run your script here.

# check if there any arguments,
if [ -z "$@" ]; then
    # if theres non, test julia:
    echo 'println("hello world from julia container!!!")' | julia
else
    # if theres an argument, then run it! and hope its a julia script :)
    julia "$@"
fi


%environment
export PATH=/julia-1.0.1/bin:$PATH
export LD_LIBRARY_PATH=/julia-1.0.1/lib:/julia-1.0.1/lib/julia:$LD_LIBRARY_PATH
export LC_ALL=C

%post
apt-get -y update
# we are installing some basic packages,
# you can install your own
#apt-get -y install <YOUR_PACKAGE>

# install some basic tools
apt-get -y install curl tar gzip

apt-get clean
apt-get autoremove

# now, download and install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

Or, you can just download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/julia.def
```

Then you can modify the `julia.def` file as you need,
e.g., installing other packages.

<br>

Now, to build the container:

```
$ sudo singularity build julia.sif julia.def
```

<br>

And you can do a quick test run:<br>
Make sure you have your [`hello-world.jl`](#make-the-test-file) test file.

```
$ ./julia.sif 
Hello world!
For full tutorial, visit: https://github.com/sylabs/examples/lang/julia
$ ./julia.sif hello-world.jl 
Hello world!
this is comming from your `hello-world.jl` script!
$ 
```

<br>

For more info on running a Julia script in a container, check out these examples:


### Running a julia script in a container:


There are several ways of doing this.

Jump to:
 - [Run script by `shell`.](#running-script-by-shell)
 - [Run script by `exec`.](#running-script-using-exec)
 - [Run scritp by `%runscript`.](#embed-the-run-command-to-runscript)
 - [Run script by embedding script to defintion file.](#embed-the-script-into-your-container)
 - [Run script by pulling from web via `curl`.](#run-the-script-by-pulling-from-the-web)


<br>


### Running script by shell:

For this example, we are going to `shell` into our container,<br>
Again, make sure you have your [`hello-world.jl`](#make-the-test-file) file and the container (`julia.sif`).

<br>

First, shell into the container:

```
$ singulairty shell julia.sif
```

<br>

And then run the script:

```
> julia hello-world.jl
```
Or
```
> chmod +x hello-world.jl
> ./hello-world.jl
```

<br>


### Running script using `exec`:

```
$ singularity exec julia.sif julia hello-world.jl
```

<br>


### Embed the run command to runscript:

```
$ nano julia.def
```
And add the command that will execute the script to `%runscript`<br>
Just copy-paste the new `%runscript` to the defintion file.
```
%runscript
# you can execute them by running:
# ./julia.sif

# you could just do:
#julia "$@"
# but if theres no arguments, you will enter the julia shell.

# this is a better way of doing it
# check if there any arguments,
if [ ! -z "$@" ]; then
    # if theres an argument, then run it! and hope its a julia script :)
    julia "$@"
else
    echo "theres no arguments!"
    echo "usage: ./julia.sif <YOUR_JULIA_SCRIPT>"
    exit 1
fi
```

<br>

Now you can run your script (`hello-world.jl`) by running:

```
$ ./julia.sif hello-world.jl
```
You can also run the container like this:
```
$ sungulairty run julia.sif hello-world.jl
```

<br>

**NOTE:** if you ever get stuck in a `julia shell`, then just press: `Ctrl^D` to exit.


<br>


### Embed the script into your container:

The script can NOT be changed once the container is built (that may be a good thing).


First edit the defintion file,<br>
You could just use `cat << EOF | julia`, and add it to your `%runscript` like this:

```
$ nano julia.def
```
```
%runscript
# are scritp that we will run:
cat << EOF | julia

println("hello world")
println("hello from julia")
println("hello from container")

EOF
```

<br>

Or a better option is to use the `%files`, like so:

```
$ nano julia.def
```
```
BootStrap: library
From: ubuntu:16.04

%runscript
# now to run the julia script, it will be in `/run/hello-world.jl`
julia /run/hello-world.jl

$files
# this will copy `hello-world.jl` to `/run/hello-world.jl` inside the container.
hello-world.jl /run/hello-world.jl

%environment
export PATH=/julia-1.0.1/bin:$PATH
export LD_LIBRARY_PATH=/julia-1.0.1/lib:/julia-1.0.1/lib/julia:$LD_LIBRARY_PATH
export LC_ALL=C

%post
apt-get -y update
# we are installing some basic packages,
# you can install your own
#apt-get -y install <YOUR_PACKAGE>

# install some basic tools
apt-get -y install curl tar gzip

apt-get clean
apt-get autoremove

# now, download and install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

<br>

By doing it this way, your `hello-world.jl` will be embedded in the container.<br>
Make sure the `hello-world.jl` is in your current directory.

<br>

Then build the container:

```
$ sudo singulairty build julia.sif julia.def
```

<br>

And run the script by:

```
$ ./julia.sif
```

<br>


### Run the script by pulling from the web:


In this example, we will use: `curl` to pull are script from github.<br>


Run the script by typing:

```
$ curl -s https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl | ./julia.sif
```

<br>

Then it will download the script from: https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl, <br>
and then run it in the container.

<br>

____


<br>
<br>
