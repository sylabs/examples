# Julia

In this example, we will cover:
 - [Pulling a julia container from the library.](#then-pull-the-container-from-the-library)
 - [Building the container from a recipe.](#to-build-from-a-recipe)
 - [Running a julia script.](#to-run-a-julia-script)

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access (only if you're [building from a recipe](#building-from-a-recipe)).
 

<br>

____


<br>


#### To start, make the working directory:

```
$ mkdir julia
$ cd julia/
```

<br>


#### Then, pull the container from the library:

```
$ singularity pull library://sylabs/examples/julia.sif:latest
```

<br>

#### Rename the container you pulled:

```
$ mv julia.sif_latest.sif julia.sif
```

<br>

#### Or you can build from a recipe.

<br>

### To build from a recipe:

You will need root access to build from a recipe.

#### First, make the definition file: (aka, the recipe)

```
$ nano julia.def
```
```
BootStrap: docker
From: ubuntu:16.04

%runscript
# run your script here, eg.
# julia testing.jl
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
apt-get -y install curl
apt-get -y install hostname 
apt-get -y install tar
apt-get -y install gzip
apt-get -y install bc
apt-get -y install less
apt-get -y install util-linux
apt-get -y install strace
apt-get -y install bzip2
apt-get -y install man-db
apt-get clean
# now, install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

#### Or, you can just download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/julia.def
```

Then you can modify the `julia.def` file as you need,
e.g., installing other packages.


<br>

#### Now, to build the container:

```
$ sudo singularity build julia.sif julia.def
```

<br>
<br>


### To run a julia script:


There are several ways of doing this.

Jump to:
 - [Run script by `shell`.](#running-script-by-shell)
 - [Run script by `exec`.](#running-script-using-exec)
 - [Run scritp by `%runscript`.](#embed-the-run-command-to-runscript)
 - [Run script by embedding script to defintion file.](#embed-the-script-into-your-container)
 - [Run script by pulling from web via `curl`.](#run-the-script-by-pulling-from-the-web)


<br>
<br>

#### Running script by shell:

```
$ nano testing.jl
```
```
#!/usr/bin/env julia


println("hello world from julia!")
```

<br>

#### Then shell into the container:

```
$ singulairty shell julia.sif
```

#### And run the script!

```
> julia testing.jl
```
Or
```
> chmod +x testing.jl
> ./testing.jl
```

<br>
<br>


#### Running script using `exec`:

<br>

```
$ singularity exec julia.sif julia testing.jl
```

<br>
<br>

#### Embed the run command to runscript:

```
$ nano julia.def
```
And add the command that will execute the script to: `%runscript`
```
BootStrap: docker
From: ubuntu:16.04

%runscript
# you can execute them by running:
# singularity run julia.sif
# run your script here, eg.
julia testing.jl

%environment
export PATH=/julia-1.0.1/bin:$PATH
export LD_LIBRARY_PATH=/julia-1.0.1/lib:/julia-1.0.1/lib/julia:$LD_LIBRARY_PATH
export LC_ALL=C

%post
apt-get -y update
# we are installing some basic packages,
# you can install your own
#apt-get -y install <YOUR_PACKAGE>
apt-get -y install curl
apt-get -y install hostname 
apt-get -y install tar
apt-get -y install gzip
apt-get -y install bc
apt-get -y install less
apt-get -y install util-linux
apt-get -y install strace
apt-get -y install bzip2
apt-get -y install man-db
apt-get clean
# now, install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

<br>

#### Now you can run your script (`testing.jl`) by running:

```
$ sungulairty run julia.sif
```

<br>
<br>


### Embed the script into your container:

The script can NOT be changed once the container is built.

<br>

#### To edit the definition file:

```
$ nano julia.jl
```
```
BootStrap: docker
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
apt-get -y install curl
apt-get -y install hostname 
apt-get -y install tar
apt-get -y install gzip
apt-get -y install bc
apt-get -y install less
apt-get -y install util-linux
apt-get -y install strace
apt-get -y install bzip2
apt-get -y install man-db
apt-get clean
# now, install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

<br>

#### Then build the container:

```
$ sudo singulairty build julia.sif julia.def
```

<br>

#### And run the script by doing:

```
$ singulairty run julia.sif
```

<br>
<br>


### Run the script by pulling from the web:

```
BootStrap: docker
From: ubuntu:16.04

%runscript
# Now we can run a script from the web
curl -s https://raw.githubusercontent.com/<USER_NAME>/<REPO_NAME>/<FILE> | julia


%environment
export PATH=/julia-1.0.1/bin:$PATH
export LD_LIBRARY_PATH=/julia-1.0.1/lib:/julia-1.0.1/lib/julia:$LD_LIBRARY_PATH
export LC_ALL=C

%post
apt-get -y update
# we are installing some basic packages,
# you can install your own
#apt-get -y install <YOUR_PACKAGE>
apt-get -y install curl
apt-get -y install hostname 
apt-get -y install tar
apt-get -y install gzip
apt-get -y install bc
apt-get -y install less
apt-get -y install util-linux
apt-get -y install strace
apt-get -y install bzip2
apt-get -y install man-db
apt-get clean
# now, install julia
curl -sSL "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.1-linux-x86_64.tar.gz" > julia.tgz
tar -C / -zxf julia.tgz
rm -f julia.tgz
```

<br>

#### Run the script by typing:

```
$ singularity run julia.sif
```

<br>

Then it will download the script from: `https://raw.githubusercontent.com/<USER_NAME>/<REPO_NAME>/<FILE>`, <br>
and then run it.

<br>
<br>


____


<br>
<br>
