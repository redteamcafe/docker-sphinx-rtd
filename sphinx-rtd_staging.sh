#!/bin/bash

#NOTE: Download Ubuntu container
docker pull ubuntu
#NOTE: Start the image
docker run -it -d --name:ubuntu ubuntu
#NOTE: Execute the installation script
docker exec -it ubuntu <script>
#NOTE: Stop the container
docker stop ubuntu
#NOTE: Commit the image
docker commit ubuntu sphinx-rtd
