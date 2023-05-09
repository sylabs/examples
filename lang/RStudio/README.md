# RStudio

RStudio is an Integrated Development Environment (IDE) for the R language. By containerizing RStudio, a scientist can leverage the reproducibility and portability of the Singularity platform, allowing them to build data visualizations and analysis tools and ensure that they behave exactly the same in a new environment.

The definiton file affords some flexibility, allowing you to run RStudio several different ways:

## Instance

 This will start up rstudio-server, on default port of 8787

```bash
singularity instance start \
  --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server \
  RStudio.sif rs --server-user=$(whoami) --www-address=0.0.0.0
```

## Run

 This will run rstudio IDE

```bash
singularity run rstudio.sif
```

## Exec

 Any program in the container, but specifically for running R directly.

```bash
singularity exec rstudio.sif R -f myfile.r
```

To build the image run:

```bash
sudo singularity build rstudio.sif RStudio.def
```

When you use run for the IDE, you may need to execute it like:

```bash
SINGULARITYENV_DISPLAY=${DISPLAY} \
  singularity run rstudio.sif
```

For a modification of rstudio-server, for example to run on port 9999:

```bash
singularity instance start \
  --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server \
  RStudio.sif rs --server-user=$(whoami) --www-address=0.0.0.0 --www-port=9999
```

You will then access your rstudio-server instance at:  [http://localhost:9999](http://localhost:9999)
