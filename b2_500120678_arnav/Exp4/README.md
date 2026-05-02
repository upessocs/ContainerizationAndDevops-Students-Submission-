# Experiment 4: Docker Essentials

## Steps Taken

- Create a simple flask application and create a *Dockerfile* using a slim python image so that an image can be built easily.

- Create a *.dockerignore* and put everything not necessarily required in the final image to reduce image size, improve build speed and also increase security.

- Build image from the *Dockerfile* 

![Last image shows the newly built my-flask-app image](Exp4.1.png)

- Tagging image 

![New tagged images](Exp4.2.png)

- History of the image

![History](Exp4.3)

- Run container on the port 3007 naming it as flask-container and also showing the logs

![curl loopback address to see response from container, showing all containers and logs](Exp4.4.png)

- Stopping and removing the container

- Multistage Dockerfile build to reduce image size and separate build and runtime environments

![Comparing sizes of the mutistage and normal build](Exp4.5.png)
Here, the size of the multistage build is more than the regular one because of not having a *.dockerignore* file and also the **COPY** command grabbing everything from the folder.

- After tagging the image for Docker Hub, we psuh the image to Docker Hub in the repository named after the user.

![Tagged and pushed to Docker Hub](Exp4.6.png)

- Image pulled from Docker Hub and container ran successfully.

![Running container](Exp4.7.png)

- Doing the same, create and app but with *node.js*, built an image from the *Dockerfile* and then running a container from that image.

![Container returning correct response from localhost](Exp4.8.png)

- Concluding, *Dockerfile* will define how to build the image, *.dockerignore* omits unnecessary details, using multistage builds for efficiency and using Docker Hub to share your images.   
