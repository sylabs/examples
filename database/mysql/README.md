## MySQL


![MySQL logo](mysql.png)

MySQL is an open source relational database management system (RDBMS). It is a central component of the LAMP open-source web application software stack.

In this example, we will generate a Singularity container running MySQL over Debian 9 (Stretch).

To run this example you will need:

 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim`, or `nano`.
 - Root access.

We'll go through the explanation of every section in the definition file:

In the `%help` section, you can find the description for the container with the respective version of MySQL installed for the specific OS distribution.

In the `%post` section, all the needed dependencies are installed to make MySQL work properly.

In the `%startscript` section, the commands needed to run an instance of MySQL are called.

In the `%runscript` section, the commands needed to run a container are called. In this case we will use this section to interact with the database.

#### Build your MySQL container using Singularity:

We will work in a directory called ` ~/mysql`, if you don't have it create it and inside get the definition file:

```
$ mkdir  ~/mysql
$ cd  ~/mysql
```

To obtain the definition file just run:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/database/mysql/mysql.def
```

After that you could simply run the following command:

```
$ sudo singularity build mysql.sif mysql.def
```

#### Build your MySQL container using the Singularity Remote Builder:

If you do not own root permissions you can always build your MySQL Singularity container with the help of our [remote builder](https://cloud.sylabs.io/builder) like so:

```
$ singularity build --remote mysql.sif mysql.def
```

If this is the first time using the Remote Builder, use the following
[instructions](https://cloud.sylabs.io/auth) to create an identification token. Your container will be built on the Remote Builder and all standard out
and standard err will be directed back to your terminal. When finished, the
container will be automatically downloaded to your local machine.

If you do not have Singularity installed on your machine, or you are in a non-Linux environment, you can also make use of the remote builder. For this, you should sign into the Sylabs Cloud and compose your definition files directly in the main window from  [Remote Builder](https://cloud.sylabs.io/builder) page. You can also drag and drop text files there. The container you build will appear under your username in the `remote-builds` collection. After this, you can download your container with the `pull` command explained below.

You can also pull the container from our library like so:

```
$ singularity pull mysql.sif library://sylabs/examples/mysql:latest
```


#### Verifying my MySQL Singularity container

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
$ singularity search mysql

No collections found for 'mysql'

Found 1 containers for 'mysql'
	library://sylabs/examples/mysql
		Tags: latest

```


After that, your MySQL Singularity container will be ready to be used. Remember that as the default port and hostname, MySQL runs on `127.0.0.1 (localhost)` and port `6379`.

#### Start an instance of your MySQL container:

Use the following command to start an instance of your MySQL Singularity container:

```
$ sudo singularity instance start -B /mysql/var/lib/mysql:/var/lib/mysql mysql.sif mysql
```
