## MongoDB

In this example, we will generate a Singularity container running Mongo database server. The versions used in this example are MongoDB v4.0.3 for Debian 9 (Stretch).

This specific version was obtained from [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/)

To run this example you will need:

	- Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
	- A text editor, like: `micro`, `vim` or `nano`.
	- Root access.

We'll go through the explanation of every section in the definition file:

In the `%help` section, you can find the description for the container with the respective version of MongoDB installed.

In the `$environment` section, the `hostname` and the `port` are set up into the environment variables `HOSTNAME` and `PORT` respectively, you might need to modify these values depending on your needs. Default `hostname` for this example is set to `localhost` (`127.0.0.1`) and `port` to `27017`.

After exporting those variables, the `%post` section contains the installation of all the needed dependencies for `MongoDB` to run correctly. Also the folders in which the data from the database will be saved are created and are also given the privilege to access and store the data.

At the end of the `%post` section, access is also given to the specific user in the specific group to the database folder in which data is stored.

Then we define a section called `%startscript` which is the section that is executed everytime a container instance is started. In here we find the commands that define a restart of the MongoDB daemon: first a stop of the daemon is executed using `mongod --repair` and then the daemon is started using the `mongod` command. After this, the service can be started with `mongo --host $HOSTNAME:$PORT` in the next line. See that `$HOSTNAME` and `$PORT` correspond to the environment variables we defined and exported at the beginning in the `%environment` section.

Another important feature to notice is that you can also refer to these environment variables on runtime with the prefix `$SINGULARITYENV_` , following this example `$SINGULARITYENV_HOSTNAME` and `$SINGULARITYENV_PORT` can be referenced from runtime.

To run the definition file and build our container, we will need to:

```
$ sudo singularity build mongodb.sif mongodb.def
```

This will generate a `mongodb.sif` Singularity image. From there, you will need to bind the `/data/db` folder from the host before running the container. This folder is where the data from the database such as logs and/or journals are stored. Open a command line and then just run:

```
$ mkdir -p mongodb/db
$ singularity shell -B mongodb/db:/data/db mongodb.sif
```

With `-B` we bind the `mongodb/db` folder on the host to the `data/db` folder that is referenced from the container.

After this we are ready to run an instance, for this we run the following command:

```
$ sudo singularity instance start mongodb.sif mongo
```

We can see there the `mongo` server running and the shell of the `mongo` server waiting for input. From here you can start setting up your database by, for example, adding a new user.

To add a new user in the database and give it a specific role, you can do so by:

First, shell into the container and run:

```
$ sudo singularity shell mongodb.sif

mongodb> mongod --repair
mongodb> mongod
mongodb> mongo
```

That will start the MongoDB shell and from there you can create a user for example:

```
> use admin

> db.createUser(
  {
    user: "myUserAdmin",
    pwd: "test",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

```

In this example, we have created a user called `myUserAdmin` with a `userAdminAnyDatabase` role and with access to the `admin` database, this user has also as a password (`pwd`) the value `test`.

After this you can exit the mongo shell and then `shell` into the container to access the database with the new created user.

You can do so by:

```
$ sudo singularity shell mongodb.sif
```

The command prompt will open and then you can access the mongo database by running:

```
$ mongod --repair
$ mongod
$ mongo --host $HOSTNAME:$PORT -u "myUserAdmin" -p "test"
```

We are logged in with the created user into the database `admin` as it was stated in the previous user creation, from this part we can also use the command to check which generated databases are available:

```
> show dbs;
```

Since we only have access to `admin` database, run the command:

```
> use admin;
```

From there we are located inside the `admin` database, and we can use CRUD operations (insert, delete or modify) through collections. In MongoDB, collections are stored in a way in which if a collection is referenced for the first time and does not exist, it will add it to the database.

To insert a new record in a new collection from our admin database run:

```
> db.newCollection1.insertOne({ x : 1 })
```

What happens next is that in the current `admin` database since there is no collection called `newCollection1` because it is the first reference to it, the collection will be created and added to the database. With the `insertOne` command instead, a Document is inserted in this specific collection.

To get information about the collections in a database you can use:

```
> db.getCollectionInfos()
```

You can find more about the different commands in MongoDB Collections [here](https://docs.mongodb.com/manual/core/databases-and-collections/#collections)

To check the specific documents inside a collection you can run:

```
> db.newCollection1.find()
```

This command is a query in which, inside the `find` method, the query criteria is defined, since in this case we have only inserted a single document we don't want to filter at all and to avoid filtering you should not pass any argument to the `find` method like we did before.

The output of course will be the document in the collection `newCollection1` we specified before.

You can also find more information about commands for Documents in MongoDB [here](https://docs.mongodb.com/manual/core/document/#documents)
