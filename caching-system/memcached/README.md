## Memcached

Memcached is a free and open source, high performance, distributed memory object caching system intended to be used to speed-up dynamic web applications by alleviating database load.

In this example, we will generate a Singularity container running Memcached v.1.5.12 for Ubuntu 18.04. This container makes use of an example using Telnet, to test if the installation is running correctly.

#### What you need:

To run this example you will need:

 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity)
 - A text editor (e.g. `vim` or `nano`)
 - Root access


#### Setting up the environment:

 To run this example, we will work on a folder called `memcached` located at the home directory. You can create it with the next command like so:

 ```
 $ mkdir ~/memcached
 $ cd ~/memcached
 ```

 You can get the definition file from:

 ```
 $ wget https://raw.githubusercontent.com/sylabs/examples/master/caching-system/memcached/memcached.def
 ```

#### Sections in the definition file:

We'll go through the explanation of every section in the definition file:

In the `%help` section, you can find the description for the container with the respective version of Memcached.

In the `%post` section, the needed dependencies are installed. Basically all the needed dependencies from Memcached and Telnet are installed in order to run the example consistently.

After this, on the `%startscript` section, whenever a container instance is started, the server is started. By default, the server will start listening on `localhost` on TCP port `11211` and UDP port `11111` on `root` user but these options can be also changed modifying the last line on the `post` section like so:

You should just edit the last line on the definition file to change the default TCP and UDP ports on the Memcached installation:

```
memcached -p 11211 -U 11111 -u root -d
```

#### Building the container:

After this, inside the `~/memcached` folder we will build our `Memcached` container. To do so:

```
$ cd ~/memcached
$ sudo singularity build memcached.sif memcached.def
```

If you do not own root permissions you can always build your Memcached Singularity container with the help of our [remote builder](https://cloud.sylabs.io/builder) like so:

```
$ singularity build --remote memcached.sif memcached.def
```

If this is the first time using the Remote Builder, use the following [instructions](https://cloud.sylabs.io/auth) to create an identification token.

Your container will be built on the Remote Builder and all standard out
and standard err will be directed back to your terminal. When finished, the
container will be automatically downloaded to your local machine.

 If you do not have Singularity installed on your machine, or you are in a non-Linux environment, you can also make use of the remote builder. For this, you should sign into the Sylabs Cloud and compose your definition files directly in the main window from  [Remote Builder](https://cloud.sylabs.io/builder) page. You can also drag and drop text files there.

 The container you build will appear under your username in the `remote-builds` collection. After this, you can download your container with the `pull` command explained below.
 You can also pull the container from our library like so:

 ```
 $ singularity pull memcached.sif library://sylabs/examples/memcached
 ```

This will generate a container called `memcached.sif`.

#### Verifying my Memcached Singularity container:

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
$ singularity search memcached
 No collections found for 'memcached'
 Found 1 containers for 'memcached'
	library://sylabs/examples/memcached
		Tags: latest
 ```


#### Start an instance of your Memcached Singularity container:

From here you will just need to run the example by:

```
$ sudo singularity instance start memcached.sif memcached
```

This will start the container instance. After this, you will be ready to shell into the container and run the example using Telnet.

#### Testing that the container is working properly with telnet

First, shell into the container like so:

```
$ sudo singularity shell memcached.sif
```

Then, connect to the default host (localhost) and default port that the Memcached daemon is listening to:

```
$ telnet 127.0.0.1 11211
```

You should see an output similar to this:

```
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
```

Now to store data for some specific amount of time we could set the following, for example let's set the variable `wookie` to value `chewbacca` for `900` seconds:

```
set wookie 0 900 9
chewbacca
```

Now hit enter, you should see the output `STORED` on the next line, like so:

```
set wookie 0 900 9
chewbacca
STORED
```

This means that the value `chewbacca` for variable `wookie` will be stored on the caching system for 900 seconds. The first `0` after `wookie` means the flag that this variable has and it's a value returned with the data that is being set. The next parameter is the expiration time, which we set to `900`, then we have the last `9` which is the number of bytes.

Let's see on this same session if the value is stored in the caching system, remember that it will expire after `900` seconds.

```
get wookie  
VALUE wookie 0 9
chewbacca
END
```

The value of the variable with the respective flags are obtained as expected.
