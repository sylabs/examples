# RStudio

RStudio is an Integrated Development Environment (IDE) for the R language. By containerizing RStudio, a scientist can leverage the reproducibility and portability of the Singularity platform, allowing them to build data visualizations and analysis tools and ensure that they behave exactly the same in a new environment. 

The definiton file affords some flexibility, allowing you to run RStudio several different ways:

## Instance:
 This will start up rstudio-server, on default port of 8787

```$ singularity instance start rstudio.sif rs```

## Run:
 This will run rstudio IDE

```$ singularity run rstudio.sif```

## Exec:
 Any program in the container, but specifically for running R directly.

```$ singularity exec rstudio.sif R -f myfile.r```

To build the image run:

```$ sudo singularity build rstudio.sif RStudio.def```

When you use run for the IDE, you may need to execute it like:


```$ SINGULARITYENV_DISPLAY=${DISPLAY} \
  singularity run rstudio.sif```

This is needed only if the `DISPLAY` environment variable does not automatically propagate from your host environment to the container.

For a modification of rstudio-server, you can create a `rstudio.conf` file, and bind mount it into the container. For example to run on port 9999:


```$ echo "www-port=9999" > rserver.conf
$ singularity instance start \
  -B rserver.conf:/etc/rstudio/rserver.conf \
  rstudio.sif rs```

You will then access your rstudio-server instance at:  [http://localhost:9999](http://localhost:9999)

