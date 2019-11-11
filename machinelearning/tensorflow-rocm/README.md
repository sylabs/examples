# tensorflow-rocm

This example provides a container for the ROCm adapted version of the
[TensorFlow](https://github.com/tensorflow/tensorflow) machine learning
framework. `tensorflow-rocm` allows machine learning computations to run on AMD
Radeon GPUs.

Singularty natively supports executing containers with ROCm applications using
the `--rocm` flag.

## Requirements

* Singularity (>=3.5.0) - Install from
  [here](https://github.com/sylabs/singularity/blob/master/INSTALL.md)
* A supported AMD GPU
* ROCm driver and libraries on the host system (>=2.8 recommended)

## Fetching the container

To fetch a pre-build version of the container from the Sylabs Library, use the
`singularity pull` command:

```
singularity pull library://sylabs/examples/tensorflow-rocm:latest
```

This will pull the latest tagged version of the container. To pull specific
versions you can use a versioned tag e.g. `1.14.2`.

## Building the container

You can build the SIF for this container locally with `singularity build`. You
will need to either run the command as root, using `sudo`, or if you have a
machine configured to use user namespaces you can use the `--fakeroot` option.

The definition file `tensorflow-rocm.def` builds a containers based on the
rocm/tensorflow dockerhub image, adding some example script.

```
sudo singularity build tensorflow-rocm.sif tensorflow-rocm.def
```

## Using the container

This example container is setup so that `singularity run --rocm
rocm_tensorflow.sif` will drop you into a shell, with some instructions covering
how to access tensorflow in various ways.

### CIFAR10 example

To test that ROCm tensorflow is working as expected, and uses your GPU
correctly, you can start the CIFAR10 training example from the
`tensorflow/models` tutorial repository:

```
singularity run --rocm tensorflow-rocm.sif
tensorflow-rocm example container
   github.com/sylabs/examples

Run 'ipython' for an interactive python shell
Run 'jupyter notebook' to startup a jupyter notebook server
Run 'cifar10_train.sh' to start the CIFAR10 training example

Singularity> cifar10_train.sh
Running CIFAR10 Training Example
Note - download of dataset on first run can take some time.
...
2019-11-11 17:02:36.884655: step 60, loss = 4.15 (259.9 examples/sec; 0.493 sec/batch)

```

You should be able to see usage of the GPU by running `rocm-smi` in another
instance of the container, or on your host:

```
$ rocm-smi


========================ROCm System Management Interface========================
================================================================================
GPU  Temp   AvgPwr  SCLK     MCLK     Fan     Perf  PwrCap  VRAM%  GPU%
0    33.0c  12.04W  1183Mhz  1500Mhz  18.82%  auto  35.0W    92%   100%
================================================================================
==============================End of ROCm SMI Log ==============================
```

### iPython shell

You can work in an interactive ipython shell by running the `ipython`
command. This will start a shell under python 3.5 where tensorflow is available:

```
$ singularity run --rocm tensorflow-rocm.sif
tensorflow-rocm example container
   github.com/sylabs/examples

Run 'ipython' for an interactive python shell
Run 'jupyter notebook' to startup a jupyter notebook server
Run 'cifar10_train.sh' to start the CIFAR10 training example

Singularity> ipython
Python 3.5.2 (default, Jul 10 2019, 11:58:48)
Type 'copyright', 'credits' or 'license' for more information
IPython 7.8.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: import tensorflow as tf
```

### Jupyter Notebook

You can work in an interactive Jupyter notebook environment by running the
`jupyter notebook` command. This will start a Jupyter server, which you can then
connect to on your host, by opening the URL that is printed out in a web
browser:

```
$ singularity run --rocm tensorflow-rocm.sif
tensorflow-rocm example container
   github.com/sylabs/examples

Run 'ipython' for an interactive python shell
Run 'jupyter notebook' to startup a jupyter notebook server
Run 'cifar10_train.sh' to start the CIFAR10 training example

Singularity> jupyter notebook
[I 17:06:25.565 NotebookApp] Serving notebooks from local directory: /home/dave/Sylabs/Git/examples/machinelearning/tensorflow-rocm
[I 17:06:25.565 NotebookApp] The Jupyter Notebook is running at:
[I 17:06:25.565 NotebookApp] http://localhost:8888/?token=c63f3cc1775b3e1e2812d72d88789b46ca20df42d3c65b8c
[I 17:06:25.565 NotebookApp]  or http://127.0.0.1:8888/?token=c63f3cc1775b3e1e2812d72d88789b46ca20df42d3c65b8c
[I 17:06:25.565 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 17:06:25.568 NotebookApp] No web browser found: could not locate runnable browser.
[C 17:06:25.568 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/dave/.local/share/jupyter/runtime/nbserver-22820-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=c63f3cc1775b3e1e2812d72d88789b46ca20df42d3c65b8c
     or http://127.0.0.1:8888/?token=c63f3cc1775b3e1e2812d72d88789b46ca20df42d3c65b8c
```

### Exec'ing a command directly

To directly run a command in the container you can `singularity exec` it, so
that you do not have to enter the container shell. E.g.:

```
$ singularity exec --rocm tensorflow-rocm.sif jupyter notebook
```



