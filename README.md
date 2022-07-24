# sphinx-rtd

Docker container image that runs on Ubuntu to deploy a webserver with sphinx and the readthedocs theme.

You can use the following script

```
bash -c "$(curl -fsSL https://raw.<content>.sh)"

```

## Creating the container automatically



## Creating the container manually

Download Ubuntu container
```
docker pull Ubuntu
```
Start the image
```
docker run -it -d --name:ubuntu ubuntu
```
Get access to container shell
```
docker exec -it ubuntu <script>
```
After that we need to add a few packages and make some changes to the container.




