# Tensorflow

[TensorFlow*](https://github.com/tensorflow/tensorflow) is a predominantly-used machine learning framework in the deep learning arena,
demanding efficient utilization of computational resources. In order to take full advantage of Intel® architecture and to extract maximum performance,
the TensorFlow framework has been optimized using Intel® Math Kernel Library for Deep Neural Networks (Intel® MKL-DNN) primitives, a popular performance library for deep learning applications

Here we are providing you with all pre-setup in singularity which is based of Tensorflow MKL [Dockerfile.devel-mkl](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.devel-mkl)
and [Dockerfile.mkl](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.mkl).


# Singularity.mkl.def

* This is a light weight definition file targeted for data scientists, to build container you need to download whl from the following URL and save in the same directory as this file.
https://pypi.org/project/intel-tensorflow/1.12.0/#files.

* Update TF_WHL with wheel name in `%post` section and read comments in `%files` section to uncomment lines as instructed.

## Build
* To build immutable containers (Production recommended).
```
    sudo singularity build <mysingularity_name>.sif Singularity.mkl.def
```
* To build development containers, Where you can install packages and modified container as needed.
```
    sudo singularity build --sandbox <mysingularity_name>/ Singularity.mkl.def
```

## Shell and Exec
Here example commands are for development container, same commands applicable to immutable containers.
Except you cannot apply `--writable` option.

`--writable`: option must be provided to install packages.
`--contain`: keeps container’s environment contained, meaning no sharing of host environment.

* Shell
```
    sudo singularity shell --contain --writable <mysingularity_name>/
```

* Exec, to run any arbitary commands from host to inside container
```
    sudo singularity exec --contain <mysingularity_name>/ env
```

## Run a instance
* Runs singularity container in background and allows to access notebook - This will run `%starscript` section commands
```
    sudo singularity instance start <mysingularity_name>/ demotest
```
* List running instances
```
    sudo singularity instance list
```
* To access notebook, you need token. Exec into one of listed instance
```
    sudo singularity exec instance://demotest jupyter notebook list
```
If you are running singularity instance in remote machine.
Execute below command to establish tunnel to forward traffic from remote machine to localhost
Ex: `ssh -L 8888:localhost:8888 <remote_machine_name>`

Access the given url from your browser and enter the access token
Ex: `localhost:8888`

# Singularity.devel-mkl.def
This definition file includes all development tools to build Tensorflow from scratch with MKL configuration.

## Build
* To build immutable containers (Production recommended).
```
    sudo singularity build <mysingularity_name>.sif Singularity.devel-mkl.def
```
* To build development containers, Where you can install packages and modified container as needed.
```
    sudo singularity build --sandbox <mysingularity_name>/ Singularity.devel-mkl.def
```

To Shell and Exec follow the same commands as above. This container does not host any notebooks. This is purely meant for development purpose.

## Run
Executes commands in `%runscript` section
```
sudo singularity run --contain <mysingularity_name>/
```