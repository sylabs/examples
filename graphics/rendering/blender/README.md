# Blender

what blender does.

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Somthing else.

<br>

#### To start, Make the working directory:
```
$ mkdir blender
$ cd blender/
```

<br>

#### Then, pull the container from the library:

```
$ singularity pull library://sylabs/examples/blender.sif:latest
```

If your building the container from a recipe, click [here](#building-the-contianer-from-a-recipe) or scroll down.

<br>

#### Now, rename the container you just pulled:

```
$ mv blender.sif_latest.sif blender.sif
```

<br>

#### Then, you can run the following to render .blend (blender scene) files:

```
$ singularity run blender.sif [scene file] [output directory] <frame | start frame:end frame>
```

<br>

The documentation for the container (%help) can be accessed by running:

```
$ singularity run-help blender.sif
```

<br>

#### Running the following will render all frames:

```
$ singularity run --nv blender.sif my_scene.blend run/output
```

<br>

#### Render frames 100-200:

```
$ singularity run --nv blender.sif my_scene.blend run/output 100:200
```

<br>

#### Render frame 5:

```
$ singularity run --nv blender.sif my_scene.blend run/output 5
```

<br>

The above examples are all using the –nv option, for bringing into the container the nVidia libraries from the host.


<br>
<br>

### Building the contianer from a recipe:

To build the container from a recipe, you will need root access, and the recipe file.

#### First, make the definition file:

```
$ foo
```


<br>
<br>



