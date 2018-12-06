# Golang container

In this example, we will compile a Go source code in a Singularity container.

<br>


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - Go source code, (like this [example](https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/hello-world.go)).

<br>



## Setup:

First, make the working directory:

```
$ mkdir golang-container
$ cd golang-container/
```

<br>

Then, pull the container from the library:

```
$ singularity pull golang.sif library://sylabs/examples/golang:latest
```

<br>

Verify the container: (Optional)

```
$ singularity verify golang.sif 
Verifying image: golang.sif
Data integrity checked, authentic and signed by:
        Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```

<br>


## Testing it:

First, we need our source code, you can download this [`hello-world.go`](https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/hello-world.go
):

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/hello-world.go
```

<br>

Compiling the code:

```
$ ./golang.sif build hello-world.go
# then run the code
$ ./hello-world
hello world!
```

The `golang.sif` is basically the `go` command, running in the container.

<br>

### Adding `golang.sif` to `$PATH`:

You could do this:

```
$ export PATH=$PATH:$HOME/golang-container/
```

<br>

But its better to copy-paste it to `~/.local/bin/`:

```
$ mkdir -p ~/.local/bin/
$ echo 'export PATH=${PATH}:${HOME}/.local/bin/' >> ~/.bashrc  # only if you dont have the ~/.local/bin/
# then cp golang.sif to ~/.local/bin/
$ cp golang.sif ~/.local/bin/
```

<br>

Now you should have `golang.sif` command.

<br>

## Building the container from a definition file:

Here's the [definition file](https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/golang.def), which can be modified as needed.

Download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/golang.def
```

<br>

Then to build the container:

```
$ sudo singularity build golang.sif golang.def
```

<br>

Or use remote builder, you don't need root access, but you do need a [access token](https://cloud.sylabs.io/auth).

```
$ singularity build --remote golang.sif golang.def
```

<br>

____

<br>


