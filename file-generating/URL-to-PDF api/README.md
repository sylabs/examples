# URL-to-PDF API

This page will demonstrate an example of packaging a service into a container and running it. The service we will be packaging is an API server that converts a web page into a PDF,i.e., can convert any URL or HTML content to a PDF file or an image (PNG/JPEG) and can be found [here](https://github.com/alvarcarto/url-to-pdf-api). This service is useful when you need to automatically produce PDF files for receipts, weekly reports, invoices, or any other type of content.

Follow the steps below to build an image required for running this service or you can just download the final image directly from Container Library, simply run
`singularity pull library://sylabs/doc-examples/url-to-pdf:latest`.


### Building the image 

This section will describe the requirements for creating the definition file (url-to-pdf.def) that will be used to build the container image. `url-to-pdf-api` is based on a Node 8 server that uses a headless version of Chromium called [Puppeteer](https://github.com/GoogleChrome/puppeteer). Let’s first choose a base from which to build our container, in this case the docker image `node:8` which comes pre-installed with Node 8 has been used:


```
Bootstrap: docker
From: node:8
Includecmd: no
```
