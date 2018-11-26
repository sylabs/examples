# Rbenv

Manage your Ruby version with Rbenv.

For This example, we will install Rbenv on your system, and we will interact with it through the container.

<br>

All you need for this example is Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).

<br>

____

<br>


### Setup:

To start, make the working directory:

This step is optional.

```
$ mkdir ~/rbenv
$ cd ~/rbenv/
```

<br>


Pulling the container:

```
$ singularity pull rbenv.sif library://sylabs/examples/rbenv:latest
```

<br>

Verify the container: (Optional)

```
$ singularity verify rbenv.sif
Verifying image: httpd.sif
Data integrity checked, authentic and signed by:
        Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```

<br>

If your building from a definition file, click [here](#building-the-container-from-a-definition-file) or scroll down for instructions.

<br>


## Usage:

Here is some basic usage for this container:

### Install Rbenv: (If its not already installed)

```
$ ./rbenv.sif install-rbenv
```

This will install Rbenv on your system, now you are ready to use it.

<br>


### Installing a Ruby version:

To install Ruby, (2.5.3 for this example) run this command:

```
$ ./rbenv.sif rbenv install 2.5.3
```

Or you can `shell` into the container and install it:

```
$ singularity shell rbenv.sif
> rbenv install 2.5.3
```

The install prossess could take more then 20 minutes, (especially for a raspberry pi).

After the install fisished, we need to make 2.5.3 the global Ruby version:

```
$ ./rbenv.sif rbenv global 2.5.3
```

Or if your shelling into the container:

```
> rbenv global 2.5.3
```

Now you can test the Ruby version:

```
$ ./rbenv.sif ruby --version
```

Or if your in the container:

```
> ruby --version
```

And the output should be somthing like:

```
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux]
```

<br>

For more info Rbenv, check out the repo [here](https://github.com/rbenv/rbenv).

<br>

## Building the container from a definition file:

You will need root access to build from a definition file, or<br>
If you have a [access token](https://cloud.sylabs.io/auth/tokens) you can use remote builder.

First, download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/ruby/rbenv/ruby.def
```

Then, build the container:

```
$ sudo singularity build rbenv.sif rbenv.def
```

Or for remote builder:

```
$ singularity build --remote rbenv.sif rbenv.def
```

Now you should have your container (`rbenv.sif`) and its ready to be used.

<br>

___

<br>
