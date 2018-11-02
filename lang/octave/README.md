# GNU Octave

![octave-logo](octave-logo.svg)

[GNU Octave](https://www.gnu.org/software/octave/) is a free and open source
(FOSS) high-level language for array manipulation and linear algebra (very 
similar to [MATLAB](https://www.mathworks.com/products/matlab.html)). It ships 
with an IDE and is very good for things like curve-fitting, modeling and 
parameter optimization, signal processing, and image manipulation.  

In this example, we'll create an Ubuntu 18.04 based container with a basic
Octave installation. The definition file will allow for easily starting the 
Octave IDE, or running a script.

## writing the definition file

First, create a directory for your Octave assets. This step is optional, but it 
will help keep your space tidy.

```
$ mkdir ~/octave && cd ~/octave
```

Open an editor (such as `nano` or `vim`) and copy the following contents into a 
 _definition file_.  In this example we will call it `octave.def` but you can 
 name it whatever you like.

```
Bootstrap: library
From: ubuntu:18.04

%post
    apt-get update && apt-get -y install octave less libcanberra-gtk3-module

%environment
    export LC_ALL=C

%runscript
    octave "$@"
```

Alternatively, you can obtain the definition file directly from this repo with 
the following command:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/octave/octave.def
```

### the definition file explained 

The definition file header instructs Singularity to download a base Ubuntu 18.04
container from the [Sylabs Container Library](https://cloud.sylabs.io/library).

The `%post` section is executed inside the container at build time.  This is 
where the container is updated and Octave is installed along with some 
dependencies. 

If you need to install additional Octave toolboxes, you can do so with `apt`.  
For instance, if you need the Octave signal processing  toolbox, add the 
following line to the `%post` section of the definition file.

```
apt-get install -y octave-signal
```

The `%environment` section defines variables that will be set during runtime. In
this case, we need to set the `LC_ALL` variable so that Octave doesn't complain
about the locale being unset.

Finally, the `%runscript` section defines the commands that the container will 
execute when it is called either with `singularity run` or called by name as if 
it were an executable.

## building the container

After writing or downloading the Octave definition file, you can build the 
container with the following command:

```
$ sudo singularity build octave.sif octave.def
```

What if you want to build a container, but you don't have administrative access
(root) in your Linux environment? You can use the
[remote builder](https://cloud.sylabs.io/builder) (assuming your environment has
access to the web) to create your container like so:

```
$ singularity build --remote octave.sif octave.def
```

If it is your first time using the Remote Builder, follow 
[these instructions](https://cloud.sylabs.io/auth) to create an identification 
token. Your container will be built on the Remote Builder and all standard out
and standard err will be directed back to your terminal. When finished, the 
container will be automatically downloaded to your local machine.

What if you don't have Singularity installed or you don't have a Linux 
environment?  After signing in to the Sylabs Cloud you can compose definition 
files directly in the window on the main 
[Remote Builder](https://cloud.sylabs.io/builder) page or drag and drop text 
files there. The containers will show up under your username in the 
`remote-builds` collection. Then you can download it with the `singularity pull`
command.

## running the container

After using one of the methods above to build your container, you can run it 
several different ways.  

### starting the Octave IDE

If you want to start an interactive development session you can either invoke
the container using the `singularity run` command, or you can treat the 
container like an executable and start it like so:

```
$ ./octave
```

The runscript within the container will execute the command `octave "$@"`. Since
no additional arguments were supplied, this is the same as simply executing the
command `octave` within the container, which will begin an interactive 
programming session. (Note that this assumes your environment can support a 
graphical user interface.)

### running a script through your octave container

If you would rather use your Octave container to execute a script, you can pass 
it as an argument. In this repo, we are providing the following example script.

```matlab
clear all
  
colors = "./leiaNewok.jpg";
input  = "./vader.jpg";
output = "./out.jpg";
ext    = "jpg";

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
colors = imread(colors);
input  = imread(input);

% flatten both images (grayscale)
flat_in = sum(input, 3);
flat_std = sum(colors, 3);

% reshape input image into vector
[rows cols rgb] = size(input);
vect_in = reshape(flat_in, rows*cols, 1);

% sort (and prepare to reverse)
[flat_std, ind_std] = sort(flat_std(:));
[vect_in, ind_in] = sort(vect_in);
tmp = 1:length(vect_in);
unsortInd(ind_in) = tmp;

for ii = 1:rgb
  
  % make colors into "sorted" vector
  this_std = colors(:, :, ii)(:);
  this_std = this_std(ind_std);
  
  % up or downsample pixels to fit input image
  x = 1/length(this_std):1/length(this_std):1;
  x1 = 1/length(vect_in):1/length(vect_in):1;
  this_std = interp1(x, this_std, x1)';
  
  % reverse sort on colors
  this_std = this_std(unsortInd);
  
  % reverse reshape 
  this_std = reshape(this_std, rows, cols);

  % replace with colors color pixels
  input(:,:,ii) = this_std;
  
end

input = uint8(input);

imwrite(input, output, format)
```

This script takes 2 images as input.  The first image (`colors`) serves as a
reference image and the second image (`input`) is an image to manipulate.  The
script will produce a new image (`output`) where the pixels of the input image
have been replaced by the pixels of the color reference image. The new image 
will have pixels arranged spatially in a manner similar to the input image, but
the color histogram will exactly match the reference image. 

Either copy and paste this script into a file called `imrecolor.m` or download 
it with the following `wget` command: 

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/lang/octave/imrecolor.m
```

If you also download the images in this repo using similar `wget` commands or by 
performing a `git clone`, you can follow along without editing the script.  If 
you would like to run this script on different images, just download them into 
the same directory and edit the first few lines of `imrecolor.m` appropriately. 

For this example, let's assume we have an image of Darth Vader with a snowy 
(Hoth?) background.

![vader](vader.jpg)

We also have a picture of princess Leia and an ewok on the forest moon of Endor.

![leiaNewok](leiaNewok.jpg)

So the obvious question arises. What if we want to redo the colors of Vader's 
picture so that it appears that _he_ is on Endor?

Luckily, you can execute the `imrecolor.m` script through the `octave.sif`
container like so:

```
$ ./octave.sif imrecolor.m
```

This will create the `out.jpg` image which clearly shows Darth Vader and his
minions in the soft glow of the forest.  

![out](out.jpg)

## obtaining and verifying this container from the Container Library

If you'd like to play around with the `octave.sif` container from this example
without building it yourself, you can always pull it from the Container Library.

If you want to find the correct URI to pull this container, (or any other one 
for that matter) use the `search` command:

```
$ singularity search octave
No users found for 'octave'

No collections found for 'octave'

Found 1 containers for 'octave'
	library://sylabs/examples/octave
		Tags: latest
```

Then you can use the listed URI to download the container like so:

```
$ singularity pull octave.sif library://sylabs/examples/octave
```

And you can verify that the container you downloaded is a bit for bit 
reproduction of the container that was used in the above example using the 
`verify` command like so:

```
$ singularity verify octave.sif
Verifying image: octave.sif
INFO:    key missing, searching key server for KeyID: EDECE4F3F38D871E...
INFO:    key retreived successfully!
Store new public key 8883491F4268F173C6E5DC49EDECE4F3F38D871E? [Y/n] y
Data integrity checked, authentic and signed by:
	Sylabs Admin <support@sylabs.io>, KeyID EDECE4F3F38D871E
```

Signing and verifying containers produces an unbroken chain of trust between the
container author and the end user.  If you want more information about signing
and verifying your own containers so that you can share them with your friends 
or colleagues securely, check the 
[Singularity docs](https://www.sylabs.io/guides/3.0/user-guide/signNverify.html).