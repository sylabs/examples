See: https://www.sylabs.io/2018/10/facebook-research-detectron/

Detectron is an object detection system written in Python and powered by Caffe2. [Detectron is a Facebook Research project](https://github.com/facebookresearch/Detectron) created to solve real world problems, particularly for deep learning applications.

Singularity provides a basis for repeatability with a container runtime that does not require root owned daemon or escalation of user privilege to run. With it's single file image format (SIF) Singularity is ideal for BYOE science (bring your own environment) and for the mobility of compute with deep learning applications.

To build the image run the following command:

```
$ sudo singularity build detectron.sif detectron.def
```

The definition file above has a `%runscript` section that allows direct execution from outside the container with the following command:

```
$ singularity run --nv detectron.sif
```

This will run detectron against the `/app/data/model_final.pkl` test data.

NOTE: Detectron currently does not have a CPU implementation; a system with one or more nVidia GPU's is required to run.

