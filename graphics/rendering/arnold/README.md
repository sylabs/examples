# Arnold

[Arnold](https://www.solidangle.com/arnold/) designed for visual effects and animation rendering, and is often used in movies and video games. Based on Monte Carlo ray tracing, this advanced version has been used in a wide array of studios and movies around the world. 

<br>

Arnold must be installed interactively. As such, the Definition file provided will
give you the base OS. 

<br>
<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access (only for build and shell).
 - Arnold, which are provided [below](#here-is-how-to-download-arnold).
 
<br>
<br>


#### Here is how to download Arnold:

Go [here](https://www.arnoldrenderer.com/arnold/try/) and download Arnold.

You will need to create an account.

#### Then copy-paste the installer to `/tmp/`:

```
$ cp ~/Downloads/MtoA-3.1.0.1-linux-2018.run /tmp/
```

The `/tmp/` directory is where we will access the installer from the container.

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

#### Next, to build the container:

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
 - Type: `accept` (if you accept them).
 - Enter: `2`for the Install mode.
 - Enter: `/opt/arnold` for the Install location.


<br>


#### Exit the container:

After the install is complete, exit the container.

```
> exit
```

<br>

#### Then, get your `.ass` file:

You can download a sample file from [here](https://support.solidangle.com/display/A5ARP/.ass+File+Examples).

For this example, we’ll use: `cornell.ass`

Then `cp` the sample file to our working directory:

(which should also be where your `arnold/` sandbox container is located)

```
$ cp ~/Downloads/cornell.ass .
```

<br>


#### Now, run the test render:

```
$ singularity run arnold/ -i cornell.ass -dw
```
Any option after the image (in this case arnold/), will be passed to the kick program.

Check output at: `cornell.jpg`.

With the `cornell.ass` example, you will get output like:

![alt text](https://www.sylabs.io/wp-content/uploads/2018/09/cornell.jpg)

*The image is from: https://www.sylabs.io/wp-content/uploads/2018/09/cornell.jpg*

<br>
<br>


### Optionally, you can also build a SIF container from the sandbox install.

Please note that this is not considered to be a best practice workflow.
If you create a SIF container from an interactive sandbox session, the definition file that is saved in the SIF sandbox will not reflect all of the changes that have been made to the container.
However, with Arnold there is no alternative but to install interactively.

#### To build the SIF container:

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

