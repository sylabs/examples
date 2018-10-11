## MongoDB

In this example, we will generate a Singularity container running Mongo database server. The versions used in this example are MongoDB v4.0.3 for Debian 9 (Stretch).

This specific version of MongoDB can also be found here from the definition file:

```
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
```

To run this example you will need:

	- Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
	- A text editor, like: `micro`, `vim` or `nano`.
	- Root access.

We'll go through the explanation of every section in the definition file:

First of all, the hostname and the port are set up into the `%environment` section, you might need to modify these values depending on your needs. Default hostname is `localhost` (`127.0.0.1`) and port `27017`.

After exporting them, the `%post` section contains the installation of all the needed dependencies for MongoDB to run correctly. Also the folders in which the data from the database will be saved are created and are also given the privilege to access and store the data.

At the end of the `%post` section, access is also given to the specific user in the specific group to the database folder in which data is stored.

Then we define a section called `%runscript` which is the section that is executed everytime the container is run. In here we find a restart of the MongoDB daemon, first a stop is done using `mongod --repair` and then the daemon is started using the `mongod` command. After this, the service can be started with `mongo --host $HOSTNAME:$PORT` in the next line. See that `$HOSTNAME` and `$PORT` correspond to the environment variables we defined and exported at the beginning in the `%environment` section.

To run the definition file and build our container, we will need to:

```
$ sudo singularity build mongodb.sif mongodb.def
```

This will generate a `mongodb.sif` image that can be run in this way:

```
$ sudo singularity run mongodb.sif
```

We can see there the `mongo` server running and the shell of the `mongo` server waiting for input. From here you can start setting up your database by, for example, adding a new user.

To add a new user in the database and give it a specific role, you can do so by:

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

 

