# Caffe

Caffe is a deep learning framework that enables the possibility to run models in GPU/CPU, it enhances the modularity and speed of models.

#### What you need:

To build this container, you will need the following:

 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - Root access.

#### Set up:

Create a folder where all of your files to the caffe singularity container including the def file will reside. In this example, we will call the folder `caffehost` and inside we will create two (2) additional folders to run the example: `data` and `examples`.

Your `/caffehost` folder should look like this:

```
/caffehost/
|-- data
|-- examples
|-- build
|   |--examples
`-- caffe.def
```
Where `caffe.def` is the definition file we will use to build the Singularity container.

#### Getting started: Building the Singularity Caffe container:

To build your container, move into the `caffehost` folder and run:

```
sudo singularity build caffe.sif caffe.def
```

We will go through a detailed explanation of the sections inside this definition file `caffe.def` :

On the `%help` section you will find a description of the container, which versions of every software is supported and over which OS image it runs.

While on the `%environment` section we will define the environment variables needed for the installation. This will be needed for running the container in an example explained later on.

On the `%post` section we describe all the needed dependencies, libraries and source code to be able to build the caffe container. For example, some modifications include specifying that this installation is only **CPU based**.

#### Prepare Bindmounts

We need to be able to write some output. Singularity runs read-only, so we will do some prep work before hand.

You can now shell into the container like so:

```
$ sudo singularity shell caffe.sif
```
**NOTE:** We are assuming you are in `/caffehost` when you run `singularity`, and that the working directory gets mounted. If this is not the case, try adding `-B /caffehost:/caffehost` to your `singularity shell` command.

Now we'll copy the data from the `caffe` install, to our writable `caffehost` location.

```
cd /caffehost
cp -a /caffe/data/* data/
```

Do the same for the examples folder:

```
cp -a /caffe/examples/* examples/
```

Finally, do the same with the `build/examples` folder:

```
cp -a /caffe/build/examples/* build/examples/
```

With this you will have the files from the container `/caffe/data` , `/caffe/examples` and `/caffe/build/examples` on your local host.

We will now `exit` the container shell.

#### Test your installation by running an example:

We can start executing the example to test our installation of Caffe inside the container:

This example is based on the `MNIST` example that appears on the Caffe website found [here](http://caffe.berkeleyvision.org/gathered/examples/mnist.html)

We need the directories we prepared earlier during our run. We will use the `SINGULARITY_BINDPATH` environment varible to set the paths we want to be bind mounted into the container when executed.

```
export SINGULARITY_BINDPATH="/caffehost/data:/caffe/data,/caffehost/examples:/caffe/examples,/caffehost/build/examples:/caffe/build/examples"
```

Move into the `/caffehost` folder and start a shell:

```
singularity shell caffe.sif
```

With the `SINGULARITY_BINDPATH` environment variable set, the locations at those mount points should be writable by our user.

We are now ready to run the example. Move to the `/caffe/data/mnist/` folder and run:

```
./get_mnist.sh
```

You should obtain an output similar to this one:

```
Downloading...
--2018-10-23 14:51:22--  http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz
Resolving yann.lecun.com (yann.lecun.com)... 216.165.22.6
Connecting to yann.lecun.com (yann.lecun.com)|216.165.22.6|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 9912422 (9.5M) [application/x-gzip]
Saving to: 'train-images-idx3-ubyte.gz'

train-images-idx3-ubyte.gz                            100%[======================================================================================================================>]   9.45M   917KB/s    in 12s     

2018-10-23 14:51:35 (809 KB/s) - 'train-images-idx3-ubyte.gz' saved [9912422/9912422]

--2018-10-23 14:51:35--  http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz
Resolving yann.lecun.com (yann.lecun.com)... 216.165.22.6
Connecting to yann.lecun.com (yann.lecun.com)|216.165.22.6|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 28881 (28K) [application/x-gzip]
Saving to: 'train-labels-idx1-ubyte.gz'

train-labels-idx1-ubyte.gz                            100%[======================================================================================================================>]  28.20K   167KB/s    in 0.2s    

2018-10-23 14:51:36 (167 KB/s) - 'train-labels-idx1-ubyte.gz' saved [28881/28881]

--2018-10-23 14:51:36--  http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz
Resolving yann.lecun.com (yann.lecun.com)... 216.165.22.6
Connecting to yann.lecun.com (yann.lecun.com)|216.165.22.6|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1648877 (1.6M) [application/x-gzip]
Saving to: 't10k-images-idx3-ubyte.gz'

t10k-images-idx3-ubyte.gz                             100%[======================================================================================================================>]   1.57M   467KB/s    in 3.8s    

2018-10-23 14:51:40 (426 KB/s) - 't10k-images-idx3-ubyte.gz' saved [1648877/1648877]

--2018-10-23 14:51:40--  http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz
Resolving yann.lecun.com (yann.lecun.com)... 216.165.22.6
Connecting to yann.lecun.com (yann.lecun.com)|216.165.22.6|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4542 (4.4K) [application/x-gzip]
Saving to: 't10k-labels-idx1-ubyte.gz'

t10k-labels-idx1-ubyte.gz                             100%[======================================================================================================================>]   4.44K  --.-KB/s    in 0.007s  

2018-10-23 14:51:40 (652 KB/s) - 't10k-labels-idx1-ubyte.gz' saved [4542/4542]

```

So now all the downloaded data sets can be seen in `/caffe/data/mnist` folder.

Now, before running the `create_mnist.sh` script located in `/caffe/examples/mnist`, we will need first to modify the paths in there. To do this, open the `create_mnist.sh` on your favorite editor and edit the following 3 lines inside the script:

```
EXAMPLE=/caffe/examples/mnist
DATA=/caffe/data/mnist
BUILD=/caffe/build/examples/mnist
```

With this configuration, now go to `/caffe/examples/mnist` and run:

```
./create_mnist.sh
```
 You should obtain an output similar to this:

 ```
 Singularity caffe.sif:/caffehost/examples/mnist> ./create_mnist.sh
 Creating lmdb...
 I1023 15:48:16.656437 14117 db_lmdb.cpp:35] Opened lmdb /caffehost/examples/mnist/mnist_train_lmdb
 I1023 15:48:16.656642 14117 convert_mnist_data.cpp:88] A total of 60000 items.
 I1023 15:48:16.656651 14117 convert_mnist_data.cpp:89] Rows: 28 Cols: 28
 I1023 15:48:21.751487 14117 convert_mnist_data.cpp:108] Processed 60000 files.
 I1023 15:48:22.010707 14134 db_lmdb.cpp:35] Opened lmdb /caffehost/examples/mnist/mnist_test_lmdb
 I1023 15:48:22.010915 14134 convert_mnist_data.cpp:88] A total of 10000 items.
 I1023 15:48:22.010923 14134 convert_mnist_data.cpp:89] Rows: 28 Cols: 28
 I1023 15:48:22.814141 14134 convert_mnist_data.cpp:108] Processed 10000 files.
 Done.
 ```

#### LeNet: the MNIST Classification Model

To run the training program, the [LeNet](http://yann.lecun.com/exdb/publis/pdf/lecun-01a.pdf) network will be used. Its use is known in digital classification tasks. For this specific case, the LeNet implementation will be changed replacing the sigmoid activations with Rectified Linear Unit (ReLU) activations for the neurons.

The layers are defined inside `/caffe/examples/mnist/lenet_train_test.prototxt`.


#### Defining the MNIST network

We will be using the `lenet_train_test.prototxt` model. This model is similar to [Google Protobuf](https://developers.google.com/protocol-buffers/docs/overview). You can find the definitions for caffe regarding protobuf in `caffe/src/caffe/proto/caffe.proto`.

The definition of the structure of layers are explained in detail [here](http://caffe.berkeleyvision.org/gathered/examples/mnist.html)

#### Training and testing the model

Training the model is very straightforward once you have written the network definition from the layers before (in protobuf format) and solver protobuf files.

First of all we will need to specify that the training needs to be run CPU-supported only, to do this you will only need to edit a single file: `lenet_solver.prototxt` located at `/caffe/examples/mnist`:

You will also need to modify the following entries inside this file:

```
net: "/caffe/examples/mnist/lenet_test.prototxt"
snapshot_prefix: "/caffe/examples/mnist/lenet"
solver_mode: CPU
```

Now to train the model we will move into  `/caffe/examples/mnist` and edit the last line on `train_lenet.sh` to:

```
/caffe/build/tools/caffe train --solver=/caffe/examples/mnist/lenet_solver.prototxt $@
```

Notice that after this modification, the execution of caffe is entirely in the container, while the configuration of the solver is in your host.

Now go inside the `/caffe` directory and run:

```
> cd /caffe
> ./examples/mnist/train_lenet.sh
```

Done, with this you will see an output that tell you about each training iteration and the results obtained.
