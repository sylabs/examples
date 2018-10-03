# Jupyter Notebook

Jupyter Notebook is an open source web application environment that allows to create and share documents that contain code, equations, visualizations and narrative text. Some use cases are data visualization, statistical modeling and machine learning.

The following example is based on Conda 4.5.11 (Canary) and Jupyter Notebook 5.6.0 for Debian 9.x (Stretch)

To build the image run the following command:

```
$ sudo singularity build jupyter.sif jupyter.def
```

The definition file above has a `%post` section in which all the dependencies are installed at build time. After that, you can start the container, it will listen by default on `localhost:8888`

```
$ singularity run jupyter.sif
```

If you would like to run it on another port (e.g. 9000) instead you can do so by:

```
$ singularity run jupyter.sif --port=9000
```

This will run Jupyter Notebook on `localhost:9000`.

And if you would like to set another hostname use `--ip` at the moment of running the image:

```
$ singularity run jupyter.sif --ip=1.1.1.1 --port=9000
```

This will run Jupyter Notebook on `1.1.1.1:9000`

See the write-up at:
https://www.sylabs.io/2018/10/jupyter-notebook/

