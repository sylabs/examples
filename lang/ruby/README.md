# Ruby

In this example, we will run a Ruby script in a container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - Ruby script, like this [`hello-world.rb`](https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/ruby.def).

<br>

____

<br>


## To start:

Make the working directory:

```
$ mkdir ~/ruby
$ cd ruby/
```

<br>

Then, pull the container:

```
$ singularity pull library://sylabs/examples/ruby:latest
```

Then change the name of the container:

```
$ mv ruby_latest.sif ruby.sif
```

Or make your own Ruby container [Here](#building-from-a-definition-file).<br>
If you make you container from a definition file, you can embed you Ruby script in the container, so it can't be changed.

<br>

## Running your script:


First you need a Ruby script, like this [`hello-world.rb`](https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/ruby.def):

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/hello-world.rb
```

<br>

Then to run the script:

```
$ ./ruby.sif ruby hello-world.rb
hello world from Ruby!
```

<br>

____


<br>

## Building from a definition file:


To build from a definition file, you will need root access.

Start by downloading the [definition file](https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/ruby.def):

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/ruby.def
```

<br>

If you want you script embeded in the container, change the `%runscript` fo this:

```
%runscript
cat << EOF | ruby

# put your ruby script here:

print "hello world from a ruby container!\n"

EOF
```

You can also use `%files` for this, check out this [Julia tutorial](https://github.com/sylabs/examples/tree/master/lang/julia#embed-the-script-into-your-container).

<br>

Then to build the container:

```
$ sudo singularity build ruby.sif ruby.def
```

<br>

To run the script:

```
$ ./ruby.sif
hello world from a ruby container!
```


<br>

____

<br>

