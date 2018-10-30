# Golang container

In this example, we will compile a go source code in a Singularity container.

<br>


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - Go source code, (like this [example](https://raw.githubusercontent.com/sylabs/examples/master/lang/golang/hello-world.go)).

<br>



## To start, make the working directory:

```
$ mkdir golang-container
$ cd goland-container/
```

<br>

Then, pull the container from the library:

```
$ singularity pull library://sylabs/examples/golang:latest
```

<br>

Rename the container:

```
$ mv golang_latest.sif golang.sif
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

The `golang.sif` is baslily the `go` command, running in the container.

<br>

Adding `golang.sif` to `$PATH`:

```
$ export PATH=$PATH:/$HOME/golang-container/
```

Now you should have `golang.sif` command.



<br>

____

<br>


