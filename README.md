# tusd 

> **tus** is a protocol based on HTTP for *resumable file uploads*. Resumable
> means that an upload can be interrupted at any moment and can be resumed without
> re-uploading the previous data again. An interruption may happen willingly, if
> the user wants to pause, or by accident in case of an network issue or server
> outage.

tusd is the official reference implementation of the [tus resumable upload
protocol](http://www.tus.io/protocols/resumable-upload.html). The protocol
specifies a flexible method to upload files to remote servers using HTTP.
The special feature is the ability to pause and resume uploads at any
moment allowing to continue seamlessly after e.g. network interruptions.

It is capable of accepting uploads with arbitrary sizes and storing them locally
on disk, on Google Cloud Storage or on AWS S3 (or any other S3-compatible
storage system). Due to its modularization and extensibility, support for
nearly any other cloud provider could easily be added to tusd.


## Starting the tusd server in Kubernetes Kind cluster

To start the tusd , refer to the commands in the available `Makefile` as we discuss them the steps necessary.

### Prerequisites
1. [Kind Installation](https://kind.sigs.k8s.io/)
2. [Docker Installation](https://www.docker.com/products/docker-desktop/)

### Steps to Follow
1. Ensure you have the latest `master` branch cloned onto your environment.
2. Navigate to the root of the esumable-upload-tusd folder you have just cloned.
3. Run this command in the command line to automatically create a new kind cluster with the appropriate configuration
   and namespace (resumable-upload) set up for you.
    ```shell
   make cluster
   ```
4. Run this command in the command line to build all components and create the docker images. This can
   be a time-consuming process when running for the first time.
    ```shell
   make publish
   ```
5. Run this command in the command line to load the docker images into the created kind cluster.
   This can be a very time-consuming process.
    ```shell
   make loadImage
   ```
6. Run this command to apply the Kubernetes configurations in the Asset Flagship Proxy Service project to the kind cluster and start the deployment!
    ```shell
   make apply
   ```
### Deleting the kind cluster
There may some reason you may have to delete your kind cluster. Run the command below in the root directory of the Asset Flagship Proxy Service project to delete the local cluster with the
namespace "asset-flagship-proxy".

````shell
make clean
````