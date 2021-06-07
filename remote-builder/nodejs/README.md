# Node.js

[Node.js](https://nodejs.org/en/) is a JavaScript runtime built on Chrome's V8 JavaScript engine.

A quick run through follows:
1. Build the container via the Sylabs Remote Builder
2. Pull the container with:
    ```sh
    singularity pull node.sif library://<cloud-image-path>
    ```
3. Run the container as an instance:
    ```sh
    singularity instance start node.sif node
    ```
4. Access the web-server via curl
    ```sh
    $ curl -i localhost:4000

    HTTP/1.1 200 OK
    X-Powered-By: Express
    Content-Type: text/html; charset=utf-8
    Content-Length: 12
    Date: Mon, 07 Jun 2021 15:26:29 GMT
    Connection: keep-alive
    Keep-Alive: timeout=5

    Hello World!
    ```
