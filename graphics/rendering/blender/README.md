# Blender

Blender is a free and open source tool used to create and render 3D graphics and animation.

In this example, we will install and run Blender in an [Ubuntu 18.04 container](https://cloud.sylabs.io/library/library/default/ubuntu).

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - An [access token](https://cloud.sylabs.io/auth) (for remote builder).
 - A Blender scene file from the [demo files](https://www.blender.org/download/demo-files/).

<br>

## To start, Make the working directory:

```
$ mkdir ~/blender
$ cd ~/blender/
```

We will run this example in the `~/blender/` directory, not necessary but it's cleaner this way.

<br>

### Pull the container from library:

```
$ singularity pull blender.sif library://sylabs/examples/blender:latest
```

If you're building the container from a definition file, click [here](#building-the-container-from-a-definition-file) or scroll down.

<br>

### Verify the container: (Optional)

```
$ singularity verify blender.sif
Verifying image: blender.sif
Data integrity checked, authentic and signed by:
        Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```


<br>

## Rendering scenes with the container:

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

The above examples use the `--nv` option to bring NVIDIA library and device
files into the container, so Blender can use your NVIDIA GPU if you have one.

If you have an AMD Radeon GPU you can use the `--rocm` option and `--bind
/etc/OpenCL`, so that blender can use the AMD libraries for OpenCL accelerated
rendering. The `--rocm` flag binds the GPU libraries and is sufficient for ROCm
GPU programs, but you must bind the OpenCL directory separately, or a specific
vendor icd file within it, to enable the OpenCL profile for the GPU. e.g.:

```
$ singularity run --rocm --bind /etc/OpenCL blender.sif my_scene.blend run/output 
```

<br>

## Running Blender Interactively:

If the system you are using has a graphical X session (desktop) running you can
run the blender program interactively from the container and use it as if it was
installed directly:

```
# For CPU rendering only
$ singularity exec blender.sif blender

# If you have an NVIDIA GPU
$ singularity exec --nv blender.sif blender

# If you have an AMD Radeon GPU
$ singularity exec --rocm --bind /etc/OpenCL blender.sif blender
```

<br>

## Building the container from a definition file:

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

<br>

Or you can use remote builder: (you will need a [access token](https://cloud.sylabs.io/auth)).

```
$ singularity build --remote blender.sif blender.def
```

Now you can [run the container](#running-the-container).


<br>

___

<br>


