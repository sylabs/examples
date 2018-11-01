## Redis

Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs, geospatial indexes with radius queries and streams.

In this example, we will generate a Singularity container running Redis server v5.0.0 over Debian 9 (Stretch).

To run this example you will need:

	- Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
	- A text editor, like: `micro`, `vim`, or `nano`.
	- Root access.

We'll go through the explanation of every section in the definition file:

In the `%help` section, you can find the description for the container with the respective version of Redis installed (5.0.0) for the specific OS distribution.

In the `%post` section, all the needed dependencies are installed to make Redis work properly.

In the `%startscript` section, the commands needed to run an instance of the Redis server are called. We will use this section to start the Redis server daemon by default in `127.0.0.1:6379`.

In the `%runscript` section, the commands needed to run a container are called. In this case we will use this section to call the Redis Client and interact with the database.

#### Build your Redis container using Singularity:

We will work in a directory called ` ~/redis`, if you don't have it create it and inside get the definition file:

```
$ mkdir  ~/redis
$ cd  ~/redis
```

To obtain the definition file just run:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/database/redis/redis.def
```

After that you could simply run the following command:

```
$ sudo singularity build redis.sif redis.def
```

After that, your Redis Singularity container will be ready to be used. Remember that as the default port and hostname, Redis takes the `127.0.0.1 (localhost)` and port `6379`.

#### Start an instance of your Redis container:

Use the following command to start an instance of your Redis Singularity container:

```
$ sudo singularity instance start redis.sif redis
```

With that we're naming and starting a new instance of the server. Now we are ready to run the container.


#### Running the Redis database client:

To run the database client, you will need to run the following command:

```
$ sudo singularity run redis.sif
```

Since the container detects the instance that called the daemon and that is already running, the expected output will be to be prompted inside the database. You should see this prompt:

```
127.0.0.1:6379>
```

Before storing some data in the database, set the following configuration:

```
127.0.0.1:6379> config set stop-writes-on-bgsave-error no
127.0.0.1:6379> config set dir ./
127.0.0.1:6379> config dbfilename temp.rdb
```

The first command means that the snapshots are disabled (this is in order to avoid saving data every specific amount of time), second command sets the working directory to save your data on a file at the local directory where you are at host and the third command is to rename the database filename to `temp.rdb`.

To test the database, we will follow an example similar to what can be obtained from [here](https://redis.io/topics/data-types-intro) specifically, on Redis Strings.

Set a variable with some value:

```
127.0.0.1:6379> set mykey somevalue
OK
```

Obtain or read the variable value from the database with the following command:

```
127.0.0.1:6379> get mykey
"somevalue"
```
