# Julia

In this example, we will run a simple `julia` container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access (only if your [building from a recipe](#building-from-a-recipe)).
 

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

### Building from a recipe:

You will need root access to build from a recipe.

#### First, make the defition file: (aka. the recipe)

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

#### Or, you can just download the defition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/julia/julia.def
```

Then you can modifie the `julia.def` file as you need,

Eg. install other packages.


<br>

#### Now to build the container:

```
$ sudo singularity build julia.sif julia.def
```

<br>
<br>


### Running a julia script:

<br>

#### First, make the script:

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

#### Output:

```
hello world from julia!
```

<br>
<br>


### Running a julia scritp without going in the container:

There are sevral ways of doing this,

<br>

#### Using `exec`

```
$ singularity exec julia.sif ./testing.jl
```

<br>

#### Or, inbed it into the defition file:

```
$ nano julia.def
```
And add the command the will execute the script to: `%runscript`
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


### Or, embed your script to the container:





<br>
<br>
