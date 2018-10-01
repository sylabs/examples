## MariaDB

In this example, we will run a database server.


What you need:
 - Singularity, you can download and install it [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - root access.
 - mySQL, installed by `sudo apt-get install mysql-server`.
 
<br>
<br>


To start, make the working directory:
```
mkdir mariadb
cd mariadb/
```

<br>

Then, make the definition file:
```
nano mariadb.def
```
```
Bootstrap: docker
From: mariadb:10.3.9

%post
    # <YOUR_USERNAME> is the user who will be executing the container,
    # just run: `whoami` and thats your username.
    # eg. sed -ie "s/^#user.*/user = westleyk/" /etc/mysql/my.cnf
    sed -ie "s/^#user.*/user = <YOUR_USERNAME>/" /etc/mysql/my.cnf


%runscript
    exec "mysqld" "$@"

%startscript
    exec "mysqld_safe"

```
**NOTE:** you can also fine the definition file in this repo.

<br>

To build the container, run:
```
sudo singularity build mariadb.sif mariadb.def
```

<br>

Then, make all the necessary directories:
```
mkdir -p mariadb/{db,run,log}
```

<br>

Now, we need to shell into the container:
```
singularity shell \
 -B mariadb/db:/var/lib/mysql \
 -B mariadb/log:/var/log/mysql \
 -B mariadb/run:/var/run/mysqld \
 mariadb.sif
```

Once we are in the container, setup mariaDB:
```
mysql_install_db
mysqld_safe --datadir=/var/lib/mysql &
```
*You may need to press `<ENTER>` to bring your prompt back.*

<br>
<br>

Now we need to secure are installation:

Remenber, we are still in the container.
```
mysql_secure_installation
```

During this procedure, you should:

 - enter your old password, there is none so just press `<ENTER>`
 - Set a new password, `[Y/n] y`
 - Type new password (remember that password)
 - Remove anonymous users, `[Y/n] y`
 - Disallow root login remotely, `[Y/n] y`
 - Remove the test database and access, `[Y/n] y`
 - Reload/flush the privilege table, `[Y/n] y`

<br>

After your are done with that, connect as the root user to the database:
```
mysql -u root -p
```
You will have to type your password you previously set.
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
use mysql;
# your promt should change to: MariaDB [mysql]>

CREATE DATABASE workdb;
CREATE USER newuser@<YOUR_IP_ADDRESS> IDENTIFIED BY "<YOUR_PASSWORD>";
# eg. CREATE USER newuser@192.168.1.55 IDENTIFIED BY "mysql-password";

GRANT ALL PRIVILEGES ON workdb.* TO newuser@<YOUR_IP_ADDRESS> WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
```
If you get an `ERROR:`, then the command was not type correctly.

After you type `exit` you should still be in the container, ie. your promt should look like this:
```
Singularity mariadb/mariadb.sif:~> 
```

<br>

Now we’ll shut down the mariadb service inside the container:
```
mysqladmin -u root -p shutdown
```

<br>

Then, exit the container:
```
exit
```

We now have a working database, and are ready to start the instance.

The Database files are stored on the host under <em>mariadb/db/</em>:
```
singularity instance start \
 -B mariadb/db:/var/lib/mysql \
 -B mariadb/log:/var/log/mysql \
 -B mariadb/run:/var/run/mysqld \
 mariadb.sif mariadb
```

<br>

The instance is started so we’ll connect to it as the "newuser" account we created:
```
mysql -u newuser -p -h <YOUR_IP_ADDRESS> workdb
```


Now your promt should look like this:
```
MariaDB [workdb]> 
```

Insert a table and data for testing:

Again, copy-paste the commands one line at a time.
```
CREATE TABLE test ( id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, name varchar(64), PRIMARY KEY (id));
INSERT INTO test (name) VALUES ('name1'),('name2');
``` 

<br>

We have now setup a small database.

Exit from the Mysql client:
```
exit
```
Then run a test query against the database:
```
mysql -u newuser -p -h <YOUR_IP_ADDRESS> workdb -e "SELECT * FROM test WHERE name = 'name2';"
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
ls -l mariadb/db/workdb/
total 120
-rw-rw---- 1 test test     65 Sep 11 15:30 db.opt
-rw-rw---- 1 test test   1498 Sep 11 15:59 test.frm
-rw-rw---- 1 test test 114688 Sep 11 16:04 test.ibd
```

<br>

To stop the instance:

First see what instances are running:
```
singularity instance list
INSTANCE NAME    PID      IMAGE
mariadb          8492     /home/ubuntu/mariadb/mariadb.sif
```
And:
```
singularity instance stop mariadb
```
Will stop `mariadb` instance.


<br>
<br>
