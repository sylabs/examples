# MariaDB

In this example, we will run a simple database server.


#### What you need:
 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity).
 - A text editor, like: `micro`, `vim` or `nano`.
 - A access token form [here](https://cloud.sylabs.io/auth) (for remote builder), or root access.
 - MySQL, installed by `sudo apt-get install mysql-server`.
 
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
# replace `your-name` with your username, run `whoami` to see your username
YOUR_USERNAME="your-name"

sed -ie "s/^#user.*/user = ${YOUR_USERNAME}/" /etc/mysql/my.cnf
chmod 1777 /run/mysqld

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

**REMEMBER** to change `<YOUR_USERNAME>` to your username, otherwise you will get this error when `> mysql_install_db`:

```
chown: invalid user: <YOUR_USERNAME>
Cannot change ownership of the database directories to the <YOUR_USERNAME>
```

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

Then, make the necessary directory:

```
$ mkdir db
```

<br>

Now, we need to shell into the container:

```
$ singularity shell --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif
```

<br>

Once we are in the container, setup MariaDB:

```
> mysql_install_db
> mysqld_safe --datadir=/var/lib/mysql &
```
*You may need to press `<ENTER>` to bring your prompt back.*

<br>

### If you get a error like:

```
>  mysql_install_db
/usr/sbin/mysqld: Can't read dir of '/etc/mysql/mariadb.conf.d/' (Errcode: 13 "Permission denied")
/usr/sbin/mysqld: Can't read dir of '/etc/mysql/conf.d/' (Errcode: 13 "Permission denied")
Fatal error in defaults handling. Program aborted
[...]
```

<br>

Then you may need to clear `/etc/apparmor.d/usr.sbin.mysqld`:<br>
`exit` the container first.

```
> exit
$ sudo truncate -s0 /etc/apparmor.d/usr.sbin.mysqld
```

<br>

Then, reboot your machine:

```
$ sudo reboot
```

**NOTE:** *You only may need to do this on `ubuntu`, Other os's like `centos`, `slackware` don't need this.*

<br>

### Secure our installation:

Remember, we are still in the container.

```
> mysql_secure_installation
```

During this procedure, you should:

 - Enter your old password. There is none just press `<ENTER>` . 
 - Set a new password. `[Y/n] y`
 - Type your new password (remember that password).
 - Remove anonymous users. `[Y/n] y`
 - Disallow root login remotely. `[Y/n] y`
 - Remove the test database and access. `[Y/n] y`
 - Reload/flush the privilege table. `[Y/n] y`

<br>

If you get a error like:

```
> mysql_secure_installation
Enter current password for root (enter for none): 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
Enter current password for root (enter for none): 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
Enter current password for root (enter for none): 
```

Then, exit the container, and stop the `mysqld daemon`:

```
> exit
$ ps aux | grep mysqld
[...]
$ kill -9 [PID]
```

Then, shell into the container again, and restart the daemon:

```
$ singularity shell --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif
> mysqld_safe --datadir=/var/lib/mysql &
```

<br>
<br>

### Connect to the database:

Once your are done with the Secure installation, connect as the root user to the database:

```
> mysql -u root -p
```
You will have to type the password you previously set.
<br>
Now your prompt should look like this:
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
# your prompt should change to: MariaDB [mysql]>

MariaDB [mysql]> CREATE DATABASE workdb;
MariaDB [mysql]> CREATE USER newuser@<YOUR_IP_ADDRESS> IDENTIFIED BY "<YOUR_PASSWORD>";
# eg. CREATE USER newuser@192.168.1.55 IDENTIFIED BY "mysql-password";

MariaDB [mysql]> GRANT ALL PRIVILEGES ON workdb.* TO newuser@<YOUR_IP_ADDRESS> WITH GRANT OPTION;
MariaDB [mysql]> FLUSH PRIVILEGES;
MariaDB [mysql]> exit
```
If you get an `ERROR:`, then the command was not typed correctly.

After you type `exit` you should still be in the container, i.e., your prompt should look like this:
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

### Starting the instance:

We now have a working database, and are ready to start the instance.

The database files are stored on the host under `mariadb/db/`:

```
$ singularity instance start --writable-tmpfs -B db/:/var/lib/mysql mariadb.sif mariadb
```

<br>

The instance is started so we’ll connect to it as the `newuser` account we created:

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
$ ls -l
total 104324
drwxr-xr-x 2 westleyk westleyk      4096 Dec 10 13:06 db
-rw-r--r-- 1 westleyk westleyk       276 Dec  7 11:33 mariadb.def
-rwxr-xr-x 1 westleyk westleyk 106819584 Dec  7 11:34 mariadb.sif
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
