# Jupyter Notebook

Jupyter Notebook is an open source web application environment that allows to create and share documents that contain code, equations, visualizations and narrative text. Some use cases are data visualization, statistical modeling and machine learning.

The following example is based on Conda 4.5.11 (Canary) and Jupyter Notebook 5.6.0 for Debian 9.x (Stretch)

#### Setting up the port and the ip:

You can edit the environment variables `JUP_PORT` and `JUP_IPNAME` from the definition file before building. Default values are set to port 8888 and ip localhost.
Feel free to set up these variables according to your needs.

After that, you can build your container with the following command:

```
$ sudo singularity build jupyter.sif jupyter.def
```

The definition file above has a `%post` section in which all the dependencies are installed at build time. After that, you can start the container, it will listen by default on `localhost:8888`, you can do this by starting an instance of the Jupyter Notebook server:

```
$ sudo singularity instance start jupyter.sif jupyter
```

See the write-up at:
https://www.sylabs.io/2018/10/jupyter-notebook/
