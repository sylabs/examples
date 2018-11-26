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

### Adding the container to your PATH:

We are going to do this without any root access, so we will install `ronn.sif` to `~/.local/bin/`:<br>
You can skip this step if you already have `${HOME}/.local/bin/`.

First, make the `${HOME}/.local/bin/`:

```
$ mkdir -p ${HOME}/.local/bin/
```

Then Add it to your PATH:

```
$ echo 'export PATH=${PATH}:${HOME}/.local/bin/' >> ~/.bashrc
$ source ~/.bashrc
```

<br>

Finaly, add `ronn.sif` to `~/.local/bin/`

```
$ mv ronn.sif ~/.local/bin/
```

<br>

## Usage:

For this example, let make a manpage for this container.

First, download the markdown file:

```
wget https://raw.githubusercontent.com/WestleyK/examples/WestleyK-ronn/file-generating/ronn/ronn.sif.md
```

<br>

Then, generate the manpage:

```
$ ronn.sif --man ronn.sif.md
```

We use the `--man` option to only generate the manpage, and not a `.html`, and `.gzip` file.<br>
So if you just want a `.gzip` file, use the `--gzip` option, same for `--html`, and `--man`.

Viewing the manpage:

```
$ man ./ronn.sif.1
```



<br>
<br>

