# Experiment 3: Deploying Nginx using different base images and comparing image layers

## Steps Taken

- Pulling image, running container and verify

Pulling latest nginx image and run container, then verify nginx

![Step 1](Exp3.1.png)

- Creating Dockerfile for Ubuntu

Dockerfile used to build Docker image with clean ubuntu installing required packages, telling container to listen to traffic on port 80 and daemon off.

![Dockerfile contents](Exp3.2.png)

- Building image and running container from Dockerfile

Using *-t* flag to tag the image as nginx-ubuntu

![Step 3](Exp3.3.png)

- Showing image size

![Large image size](Exp3.4.png)

- Creating Dockerfile for Alpine

![Dockerfile contents](Exp3.5.png)

- Building image and running container from Dockerfile

![Step 6](Exp3.6.png)

- Showing image size

![Extremely small image size](Exp3.7.png)

- Compare image sizes

According to my observation, the nginx image had the largest size followed by ubuntu but the Alpine image was vastly smaller than the other two as it only has required layers.

![Image sizes](Exp3.8.png)

- Creating and running a simple html index file on the nginx container

Create a directory with the html file and run detached with flag *-d* mapping port 80 in the container to 8083 on my device using *-p* and *-v* to mout the html file to the nginx container.

![Step 9](Exp3.9.png)

- Verify the Container

![Successfully displays content of index file](Exp.3.10.png)

- Ubuntu image took the most time to pull followed by the nginx image and the alpine image was the fastest taking only 20% of the time taken by the ubuntu image.

