# Spark

Apache Spark is a fast, in-memory data processing engine applicable to large-scale data processing, for both batch and streaming machine learning that requires fast access to data sets. Apache Spark's run-everywhere ethos is now taken a few steps further with the BYOE mentality of Singularity; bring your own environment with mobility of compute.

Spark can be a tricky application to install and configure. But by installing Spark within a Singularity container your installation becomes portable and reproducible, allowing you to spin up instances in the same way on your laptop, in an HPC center or in the cloud. Additionally, since you are using Singularity you can leverage specialized hardware on the underlying hosts like GPUs, or other hardware necessities such as host interconnects, if required by your workload.

We're going to be making a few assumptions on your setup:

You have a shared home directory across the cluster
You have passwordless access between nodes on the cluster, even to a single node
You have a directory in `$HOME` for Spark related files (i.e. `$HOME/spark`)

The SIF image can be built like so:

```
$ cd ~/spark/
$ sudo singularity build spark.sif spark.def
```

To finish the setup, it's necessary to execute a few commands from within the image in our current directory:

```
$ singularity shell spark.sif
Singularity spark.sif:~/spark>
```
While in the container shell we will run:

```
> mkdir dropbear
> cd dropbear/
> dropbearkey -t rsa -s 4096 -f dropbear_rsa_host_key
> dropbearkey -t dss -s 1024 -f dropbear_dss_host_key
> dropbearkey -t ecdsa -s 521 -f dropbear_ecdsa_host_key
> exit
```
This creates dropbear SSH keys, in our current working directory on the host, that will be readable by your user. Without these steps the files in /etc/dropbear cannot be read and the dropbear SSH server will not start.

We will now setup a directory structure to be used by Spark in the containers. Our working directory is $HOME/spark:

```
$ mkdir -p {log,run,work}
```
This creates the following directory structure  in ~/spark:

```
.
|-- dropbear/
|   |-- dropbear_dss_host_key
|   |-- dropbear_ecdsa_host_key
|   `-- dropbear_rsa_host_key
|-- log/
|-- run/
|-- spark.sif*
`-- work/
```
The preceding command created:

```
log/ -- Master/Worker logs
run/ -- Dropbear PID files
work/ -- Job work logs
```

## Single Node

As a preliminary test we'll run a single node Spark instance:

```
$ singularity instance start \
  --bind $(mktemp -d run/hostname` _XXXX):/run \
  --bind dropbear/:/etc/dropbear \
  --bind log/:/usr/local/spark/logs \
  --bind work/:/usr/local/spark/work \
  spark.sif spark-single
```
Once the instance is initiated, we'll use exec to start the Spark Master/Worker process. Here is the command run, and expected output.

```
$ singularity exec instance://spark-single /usr/local/spark/sbin/start-all.sh
starting org.apache.spark.deploy.master.Master, logging to /usr/local/spark/logs/spark-[user]-org.apache.spark.deploy.master.Master-1-[host].out
localhost: starting org.apache.spark.deploy.worker.Worker, logging to /usr/local/spark/logs/spark-[user]-org.apache.spark.deploy.worker.Worker-1-[host].out
```
You should now be able access:  https://[host]:8080 for the web interface

We can run the simple PythonPI example with:

```
$ singularity run instance://spark-single --master spark://[host]:7077 /usr/local/spark/examples/src/main/python/pi.py 50
```
When you run the container (or instance), it will execute the spark-submit application, and any option passed after the image name (`instance://spark-single` in this case) are passed to that application as options.

To cleanly shut everything down run:

```
$ singularity exec instance://spark-single stop-all.sh
$ singularity instance stop spark-single
```

## Multinode Setup

There is a small but important difference between a single node, and a multinode spark setup.

First, all slave instances should be started before you start Spark itself. So, for example we have a list of worker nodes as:

```
node0001
node0002
node0003
node0004
node0005
```
We will use node0001 as our Master node.

In $HOME/spark/, create a file named slaves that contains each of the node names, one per line. Now we will use this file, and start up our instances:

```
for host in `cat slaves`; do
    ssh ${USER}@${host} singularity instance start \
      -B $(mktemp -d $HOME/spark/run/`hostname`_XXXX):/run \
      -B $HOME/spark/dropbear/:/etc/dropbear \
      -B $HOME/spark/log/:/usr/local/spark/logs \
      -B $HOME/spark/work/:/usr/local/spark/work \
      -B $HOME/spark/slaves:/usr/local/spark/conf/slaves \
      $HOME/spark/spark.sif spark
done
```
 

Once finished, assuming we are on node0001, we can execute:

```
$ singularity exec instance://spark start-all.sh
```
This will start the Master process on node0001, and Worker processes on node000[1-5].

Once the Master process is started, if you access https://node0001:8080, for the spark page, and it should list each of the worker nodes that are started up.


