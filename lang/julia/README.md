# Julia

In this example, we will cover:
 - [Pulling a julia container from the library.](#to-start-make-the-working-directory)
 - [Building the container from a definition file.](#to-build-from-a-definition-file)
 - [Running a julia script.](#to-run-a-julia-script)

<br>

Now of corse you can build the [Official julia container from docker](https://hub.docker.com/_/julia/), <br>
But for this example we will install julia in a [Ubuntu container](https://cloud.sylabs.io/library/library/default/ubuntu). <br>


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access (only if you're [building from a definition file](#to-build-from-a-definition-file)).
 


____

<br>


### To start, make the working directory:

```
$ mkdir ~/julia
$ cd ~/julia/
```

<br>

**NOTE:** If your running on 32 bit os, you will need to build from a definition file, click [here](#to-build-from-a-definition-file) or scroll down for instructions.

Then, pull the container from the library:

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
Hello world from: https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl
For full tutorial, visit: https://github.com/sylabs/examples/lang/julia
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
# run your script here, eg.
# julia hello-world.jl
echo 'println("hello world from julia script!!!")' | julia

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

### To run a julia script:


There are several ways of doing this.

Jump to:
 - [Run script by `shell`.](#running-script-by-shell)
 - [Run script by `exec`.](#running-script-using-exec)
 - [Run scritp by `%runscript`.](#embed-the-run-command-to-runscript)
 - [Run script by embedding script to defintion file.](#embed-the-script-into-your-container)
 - [Run script by pulling from web via `curl` or `wget`.](#run-the-script-by-pulling-from-the-web)


<br>


### Running script by shell:

The test file:

```
$ nano hello-world.jl
```
```
#!/usr/bin/env julia

println("hello world from julia!")
```

Or just download the test julia file with `wget`:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl
```

<br>

Then shell into the container:

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
And add the command that will execute the script to: `%runscript`
```
BootStrap: library
From: ubuntu:16.04

%runscript
# you can execute them by running:
# singularity run julia.sif
# run your script here, eg.
julia "$@"

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

Now you can run your script (`hello-world.jl`) by running:

```
$ ./julia.sif hello-world.jl
```
You can also run the container like this:
```
$ sungulairty run julia.sif
```

<br>


### Embed the script into your container:

The script can NOT be changed once the container is built.


To edit the definition file:

```
$ nano julia.def
```
```
BootStrap: library
From: ubuntu:16.04

%runscript
# are scritp that we will run:
cat << EOF | julia

println("hello world")
println("hello from julia")
println("hello from container")

EOF

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


Then build the container:

```
$ sudo singulairty build julia.sif julia.def
```

<br>

And run the script by doing:

```
$ singulairty run julia.sif
```

<br>


### Run the script by pulling from the web:


In this example, we will use: `curl`, or `wget` to pull are script from github.<br>
Since `wget` will download the script to a file, you will need to run that file.

```
BootStrap: library
From: ubuntu:16.04

%runscript
# Now we can run a script from the web
curl -s https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl | julia

# or use wget
#wget -q https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl
#julia hello-world.jl
#rm -f hello-world.jl #(optional)

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

Run the script by typing:

```
$ ./julia.sif
Hello world from: https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl
For full tutorial, visit: https://github.com/sylabs/examples/lang/julia
$
```

<br>

Then it will download the script from: https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/hello-world.jl, <br>
and then run it.

<br>

____


<br>
<br>
