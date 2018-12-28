# h2o4gpu

H2O4GPU is an open source, GPU-accelerated machine learning package with APIs in Python and R that allows anyone to take advantage of GPUs to build advanced machine learning models. A variety of popular algorithms are available including Gradient Boosting Machines (GBM’s), Generalized Linear Models (GLM’s), and K-Means Clustering.

<https://www.h2o.ai/products/h2o4gpu/>

H2O4GPU is a collection of GPU solvers by H2Oai with APIs in Python and R. The Python API builds upon the easy-to-use scikit-learn API and its well-tested CPU-based algorithms. It can be used as a drop-in replacement for scikit-learn (i.e. import h2o4gpu as sklearn) with support for GPUs on selected (and ever-growing) algorithms. H2O4GPU inherits all the existing scikit-learn algorithms and falls back to CPU algorithms when the GPU algorithm does not support an important existing scikit-learn class option. The R package is a wrapper around the H2O4GPU Python package, and the interface follows standard R conventions for modeling.


The h2o4gpu code is at: <https://github.com/h2oai/h2o4gpu>

The metrics pR package that is used in the R sample run is located at: https://github.com/mfrasco/Metrics

### Build Instructions

```sudo singularity build h2o4gpuR.sif h2o4gpuR.def```

### Infrastructure Requirements

Nvidia GPU with Compute Capability >= 3.5

### Test the resultant container

#### Python test
Shell into the container:
```
[user@host ]$ singularity shell --nv h2o4gpuR.sif
Singularity h2o4gpuR.sif:~/singularity3_containers/h2o> python
Python 3.6.6 (default, Sep 12 2018, 18:26:19) 
[GCC 8.0.1 20180414 (experimental) [trunk revision 259383]] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import h2o4gpu
>>> import numpy as np
>>> X = np.array([[1.,1.], [1.,4.], [1.,0.]])
>>> model = h2o4gpu.KMeans(n_clusters=2,random_state=1234).fit(X)
>>> model.cluster_centers_
array([[1. , 0.5],
       [1. , 4. ]])
>>> 
Singularity h2o4gpuR.sif:~/singularity3_containers/h2o> exit
[user@host ]$ 
```

#### R test
``` 
Shell into the container:
[user@host ]$ singularity shell --nv h2o4gpuR.sif
Singularity h2o4gpuR.sif:~/singularity3_containers/h2o> R

R version 3.4.4 (2018-03-15) -- "Someone to Lean On"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> > library(h2o4gpu)

Attaching package: 'h2o4gpu'

The following object is masked from 'package:base':

    transform

> library(Metrics)
> x <- iris[1:4]
> y <- as.integer(iris$Species) # all columns, including the response, must be numeric
> model <- h2o4gpu.random_forest_classifier() %>% fit(x, y)
/usr/local/lib/python3.6/dist-packages/h2o4gpu/ensemble/weight_boosting.py:29: DeprecationWarning: numpy.core.umath_tests is an internal NumPy module and should not be imported. It will be removed in a future NumPy release.
  from numpy.core.umath_tests import inner1d
> pred <- model %>% predict(x)
/usr/local/lib/python3.6/dist-packages/sklearn/preprocessing/label.py:151: DeprecationWarning: The truth value of an empty array is ambiguous. Returning False, but in future this will result in an error. Use `array.size > 0` to check that an array is not empty.
  if diff:
> ce(actual = y, predicted = pred)
[1] 0
> q()
Save workspace image? [y/n/c]: n
Singularity h2o4gpuR.sif:~/singularity3_containers/h2o> exit
[user@host ]$ 
```
