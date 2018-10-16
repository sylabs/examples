# Weka

[Weka](https://www.cs.waikato.ac.nz/ml/weka/) is a collection of machine
learning algorithms for data mining tasks.

The full steps to install Weka into a singularity container are provided at:

 - [sylabs.io/2018/09/weka-data-mining-with-singularity](https://www.sylabs.io/2018/09/weka-data-mining-with-singularity/)

A quick run through follows:

  1) Build the Weka container using the definition file
  2) Run some toy examples using the sample data included in the container or 
     bind a host directory with the `--bind` flag to access your own data. 
