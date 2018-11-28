# Ronn

Ronn converts markdown files to manpages, and HTML manpages for the web.

Ronn is based off Ruby, and depending on your system, it could be easily installed.<br>
But what if you don't have Ronn package for your system (and don't have/want ruby installed), or you don't have root access,<br>
then heres a good example for a container use.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - A markdown test file, like [this one](https://raw.githubusercontent.com/sylabs/examples/master/file-generating/ronn/manpage-test.md).


___

<br>


### Downloading the container:

For `x86_64`:

```
$ singularity pull ronn.sif library://sylabs/examples/ronn:latest
```

For `armv7l`: (`32bit`)

```
$ singularity pull ronn.sif library://sylabs/examples/ronn-armv7l:latest
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
You can skip this step if you already have `${HOME}/.local/bin/`.<br>
Of course you can always move it to `/usr/local/bin/`, but that requires root access.

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

Finaly, move `ronn.sif` to `~/.local/bin/`

```
$ mv ronn.sif ~/.local/bin/
```

<br>

## Usage:

For this example, let make a manpage for this container.

First, download the markdown file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/file-generating/ronn/ronn.sif.md
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

### More examples:

Lets say you only want a `.gz`, and a `.html`, then run this:

```
$ ronn.sif --gzip --html your_markdown_file.md
```

Now you should have your `your_markdown_file.1.gzip`, and `your_markdown_file.1.html`.

<br>

### Specifying the output file:

To specify the output file, use the `out=` function:

```
$ ronn.sif --man out=some_output_file.1 your_markdown_file.md
```

<br>

### Making your own manpage:

You can use the [`template-manpage.md`](https://raw.githubusercontent.com/sylabs/examples/master/file-generating/ronn/template.md) to make your own manpage, just download it with `wget`:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/file-generating/ronn/template.md
```

Then modify it to fit your project need, then use `ronn.sif` to build your manpage.

<br>

___

<br>

