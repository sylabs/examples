# Arnold

[Arnold](https://www.solidangle.com/arnold/) is an advanced Monte Carlo ray tracing renderer built for the demands of feature-length animation and visual effects rendering, largely used to create movies and video games.

<br>

It must be installed interactively. So, the Definition file provided will
give you the base OS. The full steps to install Arnold into the container
are provided at:

<br>
<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access. (only for build and shell)
 - Arnold, you can download it [here](https://www.arnoldrenderer.com/arnold/try/)
 
<br>
<br>


#### To start, Download Arnold:

Go [here](https://www.arnoldrenderer.com/arnold/try/) and download Arnold,

You will need a account.

#### Then copy-paste the installer to `/tmp/`:

```
$ cp ~/Downloads/MtoA-3.1.0.1-linux-2018.run /tmp/
```

The `/tmp/` directory is were we will access the installer from the container.

<br>

#### Now, make the working directory:
```
$ mkdir arnold
$ cd arnold/
```

<br>

#### Then, we need to make the definition file:

```
$ nano arnold.def
```
```
Bootstrap: library
From: debian:9

%environment
# We will install arnold to /opt/arnold
PATH=/opt/arnold/bin:$PATH
export PATH

# If you have a license server, you can set this
# -- https://support.solidangle.com/display/A5AILIC/Setting+solidangle_LICENSE+on+the+command+line
# solidangle_LICENSE=5053@server
# export solidangle_LICENSE

%post
apt-get update
# Required by Arnold
apt-get -y install python less libx11-6
   
%runscript
# Pass any options as kick CLI options
/opt/arnold/bin/kick "$@"

```

#### Or, you can just download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/graphics/rendering/arnold/arnold.def
```

<br>

#### Then to build the container:

```
$ sudo singularity build --sandbox arnold arnold.def
```

<br>

#### Now shell into the container:

We will shell into the container with the `--writable` flag,

```
$ sudo singularity shell --writable arnold/
```

<br>


#### Install Arnold from the container:

```
> sh /tmp/MtoA-3.1.0.1-linux-2018.run
```

Read through the License Agreement
 - Type: `accept` (if accepted).
 - Enter: `2`for the Install mode.
 - Enter: `/opt/arnold` for the Install location.


<br>


#### Now exit the cotainer:

After the install is complete, exit the container,

```
> exit
```

<br>

#### Then, get you `.ass` file:

You can download a sample file from [here](https://support.solidangle.com/display/A5ARP/.ass+File+Examples)

For this example, we’ll use: `cornell.ass`

Then `cp` the sample file to are working directory:

(which should also be where your `arnold/` sandbox container is located)

```
$ cp ~/Downloads/cornell.ass .
```

<br>


#### Now, run the test render:

```
singularity run arnold/ -i cornell.ass -dw
```
Any option after the image (in this case arnold/), will be passed to the kick program.

Check output at: `cornell.jpg`

With the `cornell.ass` example, you will get output like:

![alt text](https://www.sylabs.io/wp-content/uploads/2018/09/cornell.jpg)

*The image is from: https://www.sylabs.io/wp-content/uploads/2018/09/cornell.jpg*

<br>
<br>


### Optionally you can also build a SIF image from the sandbox install.

Please note that this is not considered to be a best practice workflow.
If you create a SIF image from an interactive sandbox session, the definition file that is saved in the SIF sandbox will not 
reflect all of the changes that have been made to the image.
However, with Arnold there is no alternative but to install interactively.

#### To build the SIF image:

```
$ sudo singularity build arnold.sif arnold/
```

<br>

#### Then, remove the old test image:

```
$ rm cornell.jpg
```

<br>

#### Now, you can test it again using the SIF file:

```
$ singularity run arnold.sif -i cornell.ass -dw
```

And you should get the get the same `.jpg` image.

<br>

If you have a License for Arnold, you can set the value of solidangle_LICENSE in the `%environment` section of the Definition file, or by running Singularity and giving it the value to pass into the container:

```
$ SINGULARITYENV_solidangle_LICENSE=5053@server \
 singularity run arnold.sif -i cornell.ass -dw
```

<br>
<br>

