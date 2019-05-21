BootStrap: docker
From: nvidia/cuda:9.0-devel-ubuntu16.04
# -----------------------------------------------------------------------------------
# This is a port of the Dockerfile maintained at https://github.com/uber/horovod


%environment
# -----------------------------------------------------------------------------------

    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    export LC_ALL=C
    export HOROVOD_GPU_ALLREDUCE=NCCL
    export HOROVOD_GPU_ALLGATHER=MPI
    export HOROVOD_GPU_BROADCAST=MPI
    export HOROVOD_NCCL_HOME=/usr/local/cuda/nccl
    export HOROVOD_NCCL_INCLUDE=/usr/local/cuda/nccl/include
    export HOROVOD_NCCL_LIB=/usr/local/cuda/nccl/lib 
    export PYTHON_VERSION=2.7
    export TENSORFLOW_VERSION=1.11.0
    export PYTORCH_VERSION=0.4.1
    export CUDNN_VERSION=7.3.1.20-1+cuda9.0
    export NCCL_VERSION=2.3.5-2+cuda9.0

%post
# -----------------------------------------------------------------------------------
# this will install all necessary packages and prepare the container

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
# Python 2.7 or 3.5 is supported by Ubuntu Xenial out of the box


    export PYTHON_VERSION=2.7
    export TENSORFLOW_VERSION=1.11.0
    export PYTORCH_VERSION=0.4.1
    export CUDNN_VERSION=7.3.1.20-1+cuda9.0
    export NCCL_VERSION=2.3.5-2+cuda9.0

    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

    apt-get -y update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libcudnn7=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libnccl-dev=${NCCL_VERSION} \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev

    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install TensorFlow, Keras and PyTorch
    pip install tensorflow-gpu==${TENSORFLOW_VERSION} keras h5py torch==${PYTORCH_VERSION} torchvision

# Install the IB verbs
    apt install -y --no-install-recommends libibverbs*
    apt install -y --no-install-recommends ibverbs-utils librdmacm* infiniband-diags libmlx4* libmlx5* libnuma*

# Install Open MPI
    mkdir -p /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.2.tar.gz && \
    tar zxf openmpi-3.1.2.tar.gz && \
    cd openmpi-3.1.2 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi
    cd /root

# Install Horovod, temporarily using CUDA stubs
    ldconfig /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 pip install --no-cache-dir horovod && \
    ldconfig

# Configure OpenMPI to run good defaults:
#   --bind-to none --map-by slot --mca btl_tcp_if_exclude lo,docker0
    echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf && \
    echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf 
    #echo "btl_tcp_if_exclude = lo,docker0" >> /usr/local/etc/openmpi-mca-params.conf

# Set default NCCL parameters
    echo NCCL_DEBUG=INFO >> /etc/nccl.conf && \
    echo NCCL_SOCKET_IFNAME=^docker0 >> /etc/nccl.conf

# Download examples
    cd / && \
    apt-get install -y --no-install-recommends subversion && \
    svn checkout https://github.com/uber/horovod/trunk/examples && \
    rm -rf /examples/.svn

