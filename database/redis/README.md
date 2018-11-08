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

#### Build your Redis container using the Singularity Remote Builder:

If you do not own root permissions you can always build your Redis Singularity container with the help of our [remote builder](https://cloud.sylabs.io/builder) like so:

```
$ singularity build --remote redis.sif redis.def
```

If this is the first time using the Remote Builder, use the following
[instructions](https://cloud.sylabs.io/auth) to create an identification token. Your container will be built on the Remote Builder and all standard out
and standard err will be directed back to your terminal. When finished, the
container will be automatically downloaded to your local machine.

If you do not have Singularity installed on your machine, or you are in a non-Linux environment, you can also make use of the remote builder. For this, you should sign into the Sylabs Cloud and compose your definition files directly in the main window from  [Remote Builder](https://cloud.sylabs.io/builder) page. You can also drag and drop text files there. The container you build will appear under your username in the `remote-builds` collection. After this, you can download your container with the `pull` command explained below.

You can also pull the container from our library like so:

```
$ singularity pull library://sylabs/examples/redis:latest
```

#### Verifying my Redis Singularity container

The `verify` command allows you to verify that the container has been signed using a `PGP` key. Please remind that you should first obtain an access token from the Sylabs Cloud to make use of this feature.  Follow the steps below to generate a valid access token:

  1. Go to : https://cloud.sylabs.io/
  2. Click “Sign in to Sylabs” and follow the sign in steps.
  3. Click on your login id (same and updated button as the Sign in one).
  4. Select “Access Tokens” from the drop down menu.
  5. Click the “Manage my API tokens” button from the “Account Management” page.
  6. Click “Create”.  
  7. Click “Copy token to Clipboard” from the “New API Token” page.
  8. Paste the token string into your ~/.singularity/sylabs-token file.

Now you can verify containers that you pull from the library, ensuring they are bit-for-bit reproductions of the original
image.

```
$ singularity search redis

No collections found for 'redis'

Found 1 containers for 'redis'
	library://sylabs/examples/redis
		Tags: latest

```

And you can also pull this container as mentioned before through the `pull` command like so:

```
$ singularity pull redis.sif library://sylabs/examples/redis
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
127.0.0.1:6379> config set dbfilename temp.rdb
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
