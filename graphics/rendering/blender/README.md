# Blender

Blender is a free and open source software used for editing and rendering.

In this example, we will install Blender in a [Ubuntu container 16.04](https://cloud.sylabs.io/library/library/default/ubuntu).

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A Blender scene file from the [demo files](https://www.blender.org/download/demo-files/).

<br>

## To start, Make the working directory:

```
$ mkdir ~/blender
$ cd ~/blender/
```

We will run this example in this directory, not necessary but its cleaner.

<br>

### Then, pull the container from the library:

```
$ singularity pull blender.sif library://sylabs/examples/blender:latest
```

If your building the container from a recipe, click [here](#building-the-contianer-from-a-recipe) or scroll down.

<br>

### Verify the container: (Optional)

```
$ singularity verify blender.sif
nothing nothing
        nothing
```


<br>

### Running the container:

Now, you can run the following to render .blend (blender scene) files.<br>
Make sure you have your [blender file](https://www.blender.org/download/demo-files/).

```
$ singularity run blender.sif [scene file] [output directory] <frame | start frame:end frame>
```

<br>

The documentation for the container (`%help`) can be accessed by running:

```
$ singularity run-help blender.sif
```

<br>

Running the following will render all frames:

```
$ singularity run --nv blender.sif my_scene.blend run/output
```

<br>

Render frames 100-200:

```
$ singularity run --nv blender.sif my_scene.blend run/output 100:200
```

<br>

Render frame 5:

```
$ singularity run --nv blender.sif my_scene.blend run/output 5
```

<br>

The above examples are all using the –nv option, for bringing into the container the nVidia libraries from the host.


<br>
<br>

### Building the contianer from a recipe:

To build the container from a recipe, you will need root access, and the recipe file.

<br>

First, make the definition file:

```
$ nano blender.def
```
```
Bootstrap: library
From: ubuntu:16.04

%post
    apt-get update
    apt-get -y install blender blender-data

%help
    singularity run blender.sif [scene file] [output directory] <frame | start frame:end frame>

    Example:
    Using `my_scene.blend`, render all frames, and output into `run/output`

        singularity run blender.sif my_scene.blend run/output

    Using `my_scene.blend`, render frames 100->200, and output into `run/output`

        singularity run blender.sif my_scene.blend run/output 100:200

    Using `my_scene.blend`, render frame 5, and output into `run/output`

        singularity run blender.sif my_scene.blend run/output 5

%runscript
    FRAME="-a"
    if [ -n "$3" ]; then

        if echo $3 | grep -q ":"; then
            STARTF=$(echo $3 | cut -f 1 -d ':')
            ENDF=$(echo $3 | cut -f 2 -d ':')

            FRAME="-s ${STARTF} -e ${ENDF} -a"
        else
            FRAME="-f $3"
        fi
    fi

    echo "Command to run is: /usr/bin/blender -b -noaudio $1 -o $2 ${FRAME}"
    /usr/bin/blender -b -noaudio $1 -o $2 ${FRAME}

```

Or you can just download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/graphics/rendering/blender/blender.def
```

<br>


Then, build the container:

```
$ sudo singularity build blender.sif blender.def
```

Now you should have your container (`blender.sif`) and you don't need to download it.


<br>
<br>


