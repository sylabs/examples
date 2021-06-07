# Nginx & PHP

1. Build the container via the Sylabs Remote Builder

2. Pull container from the library
    ```sh
    singularity pull nginx.sif library://<cloud-image-path>
    ```

3. Start the container image.
    ```sh
    sudo singularity instance start --writable-tmpfs --net --network bridge --network-args "portmap=8080:80/tcp" nginx.sif nginx
    ```

4. Access the nginx container running on port 8080
    ```sh
    $ curl -i localhost:8080/index.php

    HTTP/1.1 200 OK
    Connection: keep-alive
    Content-Type: text/html; charset=UTF-8
    Date: Mon, 07 Jun 2021 15:45:43 GMT
    Server: nginx/1.21.0
    Transfer-Encoding: chunked
    X-Powered-By: PHP/8.0.6

    <h1>Hello from php and nginx in a sif</h1>
    ```