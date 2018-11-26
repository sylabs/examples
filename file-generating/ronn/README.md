# Ronn

Ronn (v0.7.3) running in a Alpine (3.8) container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - A markdown test file, like [this one](https://foo).


___

<br>


### Downloading the container:

For `x86_64`:

```
$ singularity pull ronn.sif library://sylabs/examples/ronn:latest
```

For `armv7l`: (`32bit`)

```
$ singularity pull ronn.sif library://sylabs/examples/ronn32:latest
```

<br>

Verifying the container:

```
$ singularity verify ronn.sif
Verifying image: ronn.sif
Data integrity checked, authentic and signed by:
    Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```

<br>




<br>
<br>

