# Horovod

Horovod is a distributed training framework for TensorFlow, Keras, and PyTorch. The goal of Horovod is to make distributed Deep Learning fast and easy to use.

This is a part of the Dockerfile maintained at [https://github.com/uber/horovod](https://github.com/uber/horovod)

## Instructions

A difference between the running the singularity container (vs the docker one) is that mpi runs outside of singularity thus you do not have to start the container instance on each host as detailed in the [horovod docker file](https://github.com/uber/horovod/blob/master/docs/docker.md).

### Build instructions
Download the [horovod.def](https://raw.githubusercontent.com/sylabs/examples/master/machinelearning/horovod/horovod.def) file to your local computer.

Build the sif file by executing the following command:

```
   sudo singularity build horovod.sif horovod.def
```

Copy the resultant `horovod.sif` file to all nodes you wish to run on (global storage can also be used).

### Infrastructure Requirements
Singularity 3.0 must be installed on all of the nodes you are running on.

The resultant `horovod.sif` file (from the above build step) must be located in the same directory structure on every node.

The same (or ABI compatible) version of OpenMPI has to be installed on all of the nodes you intend to run on (**NOTE:** this host version must match the OpenMPI version, or be ABI compatible, with the MPI in the container).

Nvidia GPU's must be installed and the CUDA/Nvidia drivers must be installed on the nodes (at least one per node).

An existing network infrastructure running across all nodes you intend to run on.

The ability to SSH between all of the nodes (for the user running horovod) without having to supply passwords (ssh keys setup).

Knowledge of MPI and mca parameters (these are specific to your site installation/network).

For instance, in the example runs below, native IB was used for the network connections as well as IPoIB for sideband communications. The names of the nodes were f1, f2, f3 and f4. Also, f1:2 would specify to use node f1 and to use 2 processes on that node.

### Running horovod using mpirun

Run the horovod singularity container as you would run any other MPI job. You only have to start the execution on a single node, mpirun does the rest.

**NOTE:** Resource schedulers such as SLURM can also be used to invoke the mpi execution.


### Example runs

Here is the included example `keras_mnist_advanced.py` run on 2 nodes with 2 processes per node. Each process will be using a GPU on the node:

```
[user@f1 /home/user]$ time mpirun -np 4 -H f1:2,f2:2 -x LD_LIBRARY_PATH -x PATH -x HOROVOD_MPI_THREADS_DISABLE=1 -x NCCL_SOCKET_IFNAME=^virbr0,lo -mca btl openib,self -mca pml ob1 singularity exec --nv horovod.sif python /examples/keras_mnist_advanced.py
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.

<snip>

Epoch 24/24
Epoch 24/24
Epoch 24/24
Epoch 24/24
117/117 [==============================] - 3s 30ms/step - loss: 0.0576 - acc: 0.9830 - val_loss: 0.0138 - val_acc: 0.9958
117/117 [==============================] - 4s 32ms/step - loss: 0.0554 - acc: 0.9825 - val_loss: 0.0158 - val_acc: 0.9954
117/117 [==============================] - 4s 32ms/step - loss: 0.0550 - acc: 0.9824 - val_loss: 0.0145 - val_acc: 0.9944
117/117 [==============================] - 4s 32ms/step - loss: 0.0526 - acc: 0.9839 - val_loss: 0.0143 - val_acc: 0.9955
Test loss: 0.015393297193491435
Test accuracy: 0.9951
Test loss: 0.015393297193491435
Test accuracy: 0.9951
Test loss: 0.015393297193491435
Test accuracy: 0.9951
Test loss: 0.015393297193491435
Test accuracy: 0.9951

real	1m46.582s
user	6m12.251s
sys	0m57.313s
[user@f1 /home/user]$ 
```

Now here is the same example `keras_mnist_advanced.py` run on 4 nodes with 2 processes per node:

```
[user@f1 /home/user]$ time mpirun -np 8 -H f1:2,f2:2,f3:2,f4:2  -x LD_LIBRARY_PATH -x PATH -x HOROVOD_MPI_THREADS_DISABLE=1 -x NCCL_SOCKET_IFNAME=^virbr0,lo -mca btl openib,self -mca pml ob1 singularity exec --nv horovod.sif python /examples/keras_mnist_advanced.py
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.
Using TensorFlow backend.

<snip>

58/58 [==============================] - 2s 30ms/step - loss: 0.0522 - acc: 0.9852 - val_loss: 0.0169 - val_acc: 0.9941
58/58 [==============================] - 2s 30ms/step - loss: 0.0600 - acc: 0.9822 - val_loss: 0.0148 - val_acc: 0.9968
58/58 [==============================] - 2s 30ms/step - loss: 0.0623 - acc: 0.9809 - val_loss: 0.0154 - val_acc: 0.9949
58/58 [==============================] - 2s 30ms/step - loss: 0.0648 - acc: 0.9799 - val_loss: 0.0184 - val_acc: 0.9943
58/58 [==============================] - 2s 31ms/step - loss: 0.0646 - acc: 0.9826 - val_loss: 0.0134 - val_acc: 0.9965
58/58 [==============================] - 2s 30ms/step - loss: 0.0656 - acc: 0.9797 - val_loss: 0.0171 - val_acc: 0.9946
58/58 [==============================] - 2s 31ms/step - loss: 0.0676 - acc: 0.9809 - val_loss: 0.0158 - val_acc: 0.9952
58/58 [==============================] - 2s 32ms/step - loss: 0.0751 - acc: 0.9763 - val_loss: 0.0182 - val_acc: 0.9938
Test loss: 0.016484901236399993
Test accuracy: 0.9947
Test loss: 0.016484901236399993
Test accuracy: 0.9947
Test loss: 0.016484901236399993
Test accuracy: 0.9947
Test loss: 0.016484901236399993
Test accuracy: 0.9947
Test loss: 0.01648490226028439
Test accuracy: 0.9947
Test loss: 0.01648490226028439
Test accuracy: 0.9947
Test loss: 0.01648490226028439
Test accuracy: 0.9947
Test loss: 0.01648490226028439
Test accuracy: 0.9947

real	1m0.727s
user	3m55.237s
sys	0m42.098s
[user@f1 /home/user]$ 
```

