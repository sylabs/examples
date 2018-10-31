# Ruby

In this example, we will run a Ruby script in a container.

<br>

#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - Ruby script, like this [`hello-world.rb`]().

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


First you need a Ruby script, like this [`hello-world.rb`]():

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/hello-world.rb
```

<br>

Then to run the script:

```
$ ./ruby.sif ruby hello-world.rb
```




<br>

____


<br>



## Building from a definition file:







<br>
<br>

