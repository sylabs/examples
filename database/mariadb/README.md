## MariaDB

In this example, we will run a simple database server.


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A access token form [here](https://cloud.sylabs.io/auth) (for remote builder), or root access.
 - mySQL, installed by `sudo apt-get install mysql-server`.
 
<br>

____

<br>


### To start, make the working directory:
```
$ mkdir ~/mariadb
$ cd ~/mariadb/
```

<br>

Then, make the definition file:

```
$ nano mariadb.def
```
```
Bootstrap: docker
From: mariadb:10.3.9

%post
# <YOUR_USERNAME> is the user who will be executing the container,
# just run: `whoami` and that's your username.
# eg. sed -ie "s/^#user.*/user = westleyk/" /etc/mysql/my.cnf
sed -ie "s/^#user.*/user = <YOUR_USERNAME>/" /etc/mysql/my.cnf


%runscript
exec "mysqld" "$@"

%startscript
exec "mysqld_safe"
```

Or you can download the definition file:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/database/mariadb/mariadb.def
```

<br>

**REMEMBER** to change `<YOUR_USERNAME>` to your username.

<br>

To build the container, run:

```
$ sudo singularity build mariadb.sif mariadb.def
```

Or use remote builder:

```
$ singularity build --remote mariadb.sif mariadb.def
```

You don't need root access to use remote builder, but you do need a token, click [here](https://cloud.sylabs.io/auth) for more information.

<br>

Then, make all the necessary directories:

```
$ mkdir -p mariadb/{db,run,log}
```

<br>

Now, we need to shell into the container:

```
$ singularity shell \
 -B mariadb/db:/var/lib/mysql \
 -B mariadb/log:/var/log/mysql \
 -B mariadb/run:/var/run/mysqld \
 mariadb.sif
```

<br>

Once we are in the container, setup MariaDB:

```
> mysql_install_db
> mysqld_safe --datadir=/var/lib/mysql &
```
*You may need to press `<ENTER>` to bring your prompt back.*

<br>
<br>

Now we need to secure our installation:<br>
Remember, we are still in the container.

```
> mysql_secure_installation
```

During this procedure, you should:

 - Enter your old password. If there is none just press `<ENTER>` . 
 - Set a new password. `[Y/n] y`
 - Type your new password (remember that password).
 - Remove anonymous users. `[Y/n] y`
 - Disallow root login remotely. `[Y/n] y`
 - Remove the test database and access. `[Y/n] y`
 - Reload/flush the privilege table. `[Y/n] y`

<br>

Once your are done with that, connect as the root user to the database:

```
> mysql -u root -p
```
You will have to type the password you previously set.
<br>
Now your promt should look like this:
```
MariaDB [(none)]>
```

<br>

Now we can create a new database and user:

Just copy-paste these commands, <br>
`<YOUR_IP_ADDRESS>` = your ip address from: `hostname -I`. <br>
`<YOUR_PASSWORD>` = your password you previously set. <br>

```
MariaDB [(none)]> use mysql;
# your promt should change to: MariaDB [mysql]>

MariaDB [mysql]> CREATE DATABASE workdb;
MariaDB [mysql]> CREATE USER newuser@<YOUR_IP_ADDRESS> IDENTIFIED BY "<YOUR_PASSWORD>";
# eg. CREATE USER newuser@192.168.1.55 IDENTIFIED BY "mysql-password";

MariaDB [mysql]> GRANT ALL PRIVILEGES ON workdb.* TO newuser@<YOUR_IP_ADDRESS> WITH GRANT OPTION;
MariaDB [mysql]> FLUSH PRIVILEGES;
MariaDB [mysql]> exit
```
If you get an `ERROR:`, then the command was not typed correctly.

After you type `exit` you should still be in the container, i.e., your promt should look like this:
```
Singularity mariadb/mariadb.sif:~> 
```

<br>

Now we’ll shut down the MariaDB service inside the container:

```
> mysqladmin -u root -p shutdown
```

<br>


Then, exit the container:

```
> exit
```

We now have a working database, and are ready to start the instance.

The database files are stored on the host under <em>mariadb/db/</em>:
```
$ singularity instance start \
 -B mariadb/db:/var/lib/mysql \
 -B mariadb/log:/var/log/mysql \
 -B mariadb/run:/var/run/mysqld \
 mariadb.sif mariadb
```

<br>

The instance is started so we’ll connect to it as the "newuser" account we created:

```
$ mysql -u newuser -p -h <YOUR_IP_ADDRESS> workdb
```


Now your promt should look like this:

```
MariaDB [workdb]> 
```

Insert a table and data for testing:

Again, copy-paste the commands one line at a time.

```
MariaDB [workdb]> CREATE TABLE test ( id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, name varchar(64), PRIMARY KEY (id));
MariaDB [workdb]> INSERT INTO test (name) VALUES ('name1'),('name2');
``` 

<br>

We have now setup a small database.

Exit from the Mysql client:

```
MariaDB [workdb]> exit
```

<br>

Then run a test query against the database:

```
$ mysql -u newuser -p -h <YOUR_IP_ADDRESS> workdb -e "SELECT * FROM test WHERE name = 'name2';"
# eg. mysql -u newuser -p -h 192.168.1.55 workdb -e "SELECT * FROM test WHERE name = 'name2';"
```
And type your password.


Your output should be:
```
+----+-------+
| id | name  |
+----+-------+
|  2 | name2 |
+----+-------+
```

<br>

And on our host are the database files, owned by our user.
```
$ ls -l mariadb/db/workdb/
total 120
-rw-rw---- 1 test test     65 Sep 11 15:30 db.opt
-rw-rw---- 1 test test   1498 Sep 11 15:59 test.frm
-rw-rw---- 1 test test 114688 Sep 11 16:04 test.ibd
```

<br>

### To stop the instance:

First see what instances are running:
```
$ singularity instance list
INSTANCE NAME    PID      IMAGE
mariadb          8492     /home/ubuntu/mariadb/mariadb.sif
```
And:
```
$ singularity instance stop mariadb
```
will stop `mariadb` instance.


<br>

___

<br>
