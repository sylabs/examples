# RabbitMQ

RabbitMQ is a message broker that supports multiple messaging protocols.

In this example, we will generate a Singularity container running RabbitMQ 3.7.8 for Alpine Linux 3.8.
This container also includes the installation of Python 3.7.1 to follow the example on sending and receiving a message to the queue.


#### What you need:

To run this example you will need:

 - Singularity, which you can download and install from [here](https://github.com/sylabs/singularity)
 - A text editor (e.g. `vim` or `nano`)
 - Root access

#### Sections in the definition file:

We'll go through the explanation of every section in the definition file:

In the `%help` section, you can find the description for the container with the respective version of RabbitMQ, Python (needed to run the example) and Alpine.

In the `%environment` section, the environment variables needed are defined.

In the `%post` section, the needed dependencies are installed and also the exported variables are defined. Basically all the needed dependencies from Erlang and Python are installed in order to run the example consistently.

After this, on the `%startscript` section, whenever a container instance is started, the server is started and the status is printed on the output of the console. By default, the server will start listening on node `localhost` on port `5672`.

#### Setting up the environment:

To run this example, we will work on a folder called `rabbitmq` located at the home directory. You can create it with the next command like so:

```
$ mkdir ~/rabbitmq
$ cd ~/rabbitmq
```

After this, we will need the next folders inside  `~/rabbitmq`:

```
$ mkdir -p ~/rabbitmq/var/{lib/rabbitmq,log}
```

Then, please do make sure you have the following directory structure before following the example:

 ```
 ~/rabbitmq
       `---var
              |--lib
              |   `--rabbitmq
              `--log
```

You can get the definition file from:

```
$ wget https://raw.githubusercontent.com/sylabs/examples/master/message-broker/rabbitmq/rabbitmq.def
```

You will also need to have on `~/rabbitmq` two Python scripts we will create on the host using the Python Pika libraries we installed inside the container. You can use your favorite editor for this. The two files we will create will be called `send.py` and `receive.py` respectively and will reside on our working folder ` ~/rabbitmq`.

The code inside the `send.py` file is this one:

```
#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()


channel.queue_declare(queue='hello')

channel.basic_publish(exchange='',
                      routing_key='hello',
                      body='Hello World from RabbitMQ on Singularity!')
print(" [x] Sent 'Hello World from RabbitMQ on Singularity!'")
connection.close()
```

And on the `receive.py` you should add:

```
#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()


channel.queue_declare(queue='hello')

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(callback,
                      queue='hello',
                      no_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
```

We will see an explanation of this code below when we run the example.

#### Building the container:

After this, inside the `~/rabbitmq` folder we will build our `RabbitMQ` container. To do so:

```
$ cd ~/rabbitmq
$ sudo singularity build rabbitmq.sif rabbitmq.def
```

If you do not own root permissions you can always build your RabbitMQ Singularity container with the help of our [remote builder](https://cloud.sylabs.io/builder) like so:

```
$ singularity build --remote rabbitmq.sif rabbitmq.def
```

If this is the first time using the Remote Builder, use the following [instructions](https://cloud.sylabs.io/auth) to create an identification token.

Your container will be built on the Remote Builder and all standard out
and standard err will be directed back to your terminal. When finished, the
container will be automatically downloaded to your local machine.

 If you do not have Singularity installed on your machine, or you are in a non-Linux environment, you can also make use of the remote builder. For this, you should sign into the Sylabs Cloud and compose your definition files directly in the main window from  [Remote Builder](https://cloud.sylabs.io/builder) page. You can also drag and drop text files there.

 The container you build will appear under your username in the `remote-builds` collection. After this, you can download your container with the `pull` command explained below.
 You can also pull the container from our library like so:

 ```
 $ singularity pull rabbitmq.sif library://sylabs/examples/rabbitmq
 ```

This will generate a container called `rabbitmq.sif`.

#### Verifying my RabbitMQ Singularity container:

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
$ singularity search rabbitmq
 No collections found for 'rabbitmq'
 Found 1 containers for 'rabbitmq'
	library://sylabs/examples/rabbitmq
		Tags: latest
 ```


#### Start an instance of your RabbitMQ Singularity container:

From here you will just need to run the example by:

```
$ sudo singularity instance start --bind ~/rabbitmq/var/lib:/var/lib,~/rabbitmq/var/lib/rabbitmq:/var/lib/rabbitmq,~/rabbitmq/var/log:/var/log rabbitmq.sif
```

This will start the container instance and at the same time bind all the needed folders we generated previously. Since at the very beginning all those folders on our `RabbitMQ` container are empty, there is no risk of removing them at the binding process.

Then, you will see the instance started with the command line output similar to this one:

```
2018-11-14 14:41:24.851 [info] <0.33.0> Application rabbit started on node 'rabbit@localhost'
2018-11-14 14:41:24.950 [info] <0.5.0> Server startup complete; 0 plugins started.
 completed with 0 plugins.
```

#### Run the Python Pika example:

Open another command line, we will now make use of the generated Python scripts on the set up section to see if the protocol of RabbitMQ is working correctly.

As it's known, RabbitMQ is a message broker so it means that it accepts and forwards messages. The messages are binary blobs of data. The protocol used is the one of "Consumer-Producer" on the sense that, whenever there is a "producing" it means that the message is being sent, while the "consumer" means that the message has been received.

The queue is where the messages arrive from the producer, you can think of it as a mail box, where RabbitMQ is both the post office and the postman.

A queue is bound only by the host's memory and the disk limits, it is like a large message buffer. Many producers can send messages to one queue, and many consumers can try to receive the data from one queue.

You can see a graphic of this process right below:

![RabbitMQ Protocol](protocol.png)

On the image, a producer sends messages to the "hello" queue, the consumer then receives the messages from that queue.

RabbitMQ speaks `AMQP 0.9.1` which is an open, general-purpose protocol for messaging. There are a number of clients for RabbitMQ in many different languages. In this tutorial we will use Pika 0.11.0, which is the Python client recommended by the RabbitMQ team. It is already installed in our Singularity container.

#### Explanation of the send.py program:

On our example. we will use the program `send.py` we created to send a single message saying "Hello World from RabbitMQ on a Singularity container!". We will go through the code of `send.py` we created before:

On these lines:

```
#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
```

The connection is established to the broker on the local machine (localhost). If we would like to connect to another broker we should just change `localhost` to the specific IP address.

Next, we need to be sure that before sending the message, the queue exists. For this issue, the following instruction is called:

```
channel.queue_declare(queue='hello')
```

The location, or the queue's name is "hello" in this example.

After this we are ready to send a message, for this we will use:

```
channel.basic_publish(exchange='',
                      routing_key='hello',
                      body='Hello World from RabbitMQ on a Singularity container!')
print(" [x] Sent 'Hello World from RabbitMQ on a Singularity container!'")
```

Notice that there we specified explicitly that the location should be the "hello" queue. The message content corresponds to the body of the message.

Before exiting, we will need to make sure that the network buffers were flushed and our message was actually delivered to RabbitMQ. We can do this by closing the connection.

```
connection.close()
```

#### Explanation of the receive.py program:

The second program we created will be in charge of receiving the message that we sent using `send.py`. For this, we will again need to connect to the RabbitMQ server, then we will check again that the location of queue "hello" exists, so in practice these two instructions are pretty much the same, what changes is the following part on the code:

```
def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)
```

There, we receive the message by calling a "callback" function that will print on screen the content of the message received. Since in this case we are "consuming" the message, we will need to use another method to receive the message:

```
channel.basic_consume(callback,
                      queue='hello',
                      no_ack=True)
```

With this, on the location queue "hello" and with the function callback we defined previously, we explicitly say that we will receive a message from that location. (The `no_ack` is set to True in this case to avoid acknowledgment messages but it could be set to False depending on your needs, for this example it will be set to True).


Finally, we enter to a never-ending loop by waiting for data from that location queue and running the callback function whenever it's necessary:

```
print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
```


#### Running the example:

To run the example, at this point you should have one console running the instance of the RabbitMQ server, open another console, shell and bind into the container and run the `receive.py` program like so:

```
$ sudo singularity shell --bind ~/rabbitmq/var/lib:/var/lib,~/rabbitmq/var/lib/rabbitmq:/var/lib/rabbitmq,~/rabbitmq/var/log:/var/log rabbitmq.sif
Singularity> python3 ./receive.py
```

You should be asking yourself: why are we first running the "receiver" when we still haven't sent any message? And the reason for this is that the consumer will need to listen constantly for messages on a location, is the most similar to a subscription of a specific location where it wants to hear from.

After running that last command, you should see this output:

```
Singularity> python3 ./receive.py
 [*] Waiting for messages. To exit press CTRL+C
```

Next, we are ready to send the message, open another console and then shell, bind into the container and run the `send.py` program like so:

```
$ sudo singularity shell --bind ~/rabbitmq/var/lib:/var/lib,~/rabbitmq/var/lib/rabbitmq:/var/lib/rabbitmq,~/rabbitmq/var/log:/var/log rabbitmq.sif
Singularity> python3 ./send.py
```

After that last command, you should see the following output in this console:

```
Singularity> python3 ./send.py
 [x] Sent 'Hello World from RabbitMQ on a Singularity container!'
```

Notice that since the receiver's command line (the console in which we ran `receive.py`) was listening and waiting for messages, now it should print out the received message:

```
Singularity> python3 ./receive.py
 [*] Waiting for messages. To exit press CTRL+C
 [x] Received b'Hello World from RabbitMQ on a Singularity container!'
```

And we can see it printed out in the third line, which means that the message was successfully received.
