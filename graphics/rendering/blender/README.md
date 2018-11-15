# Blender

Blender is a free and open source software used for editing and rendering.

In this example, we will run Blender in a [Ubuntu container 16.04](https://cloud.sylabs.io/library/library/default/ubuntu).

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

We will run this example in the `~/blender/` directory, not necessary but its cleaner this way.

<br>

### Then, pull the container from the library:

```
$ singularity pull blender.sif library://sylabs/examples/blender:latest
```

If your building the container from a recipe, click [here](#building-the-contianer-from-a-definition-file) or scroll down.

<br>

### Verify the container: (Optional)

```
$ singularity verify blender.sif
Verifying image: blender.sif
Data integrity checked, authentic and signed by:
        Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```


<br>

## Running the container:

Now, you can run the following to render `.blend` (blender scene) files.<br>
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

The above examples are all using the `–-nv` option, for bringing into the container the nVidia libraries from the host.


<br>
<br>

## Building the contianer from a definition file:

To build the container from a recipe, you will need root access, and the recipe file.

First, download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/graphics/rendering/blender/blender.def
```

<br>

Then, build the container:

```
$ sudo singularity build blender.sif blender.def
```

Now you can [run the container](#running-the-container).


<br>

___

<br>


