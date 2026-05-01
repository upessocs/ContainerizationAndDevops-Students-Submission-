# 03.02.26 - Docker Daemon & REST API (Class Work)

It is related to Docker daemon verification and basic interaction with Docker using its REST API.



### Step 1: Checked Docker socket
We first checked whether the Docker socket exists and is accessible.

Command used:
```bash
ls -l /var/run/docker.sock
```
This showed that /var/run/docker.sock is linked to the Docker Desktop socket location, confirming that Docker daemon is running.

![](./Images/1.png)

### Step 2: Pinged Docker daemon using curl
We used curl with the Unix socket to check if Docker is responding.

Command used:
```bash
curl --unix-socket /var/run/docker.sock http://localhost/_ping
```
Output:

OK
This confirmed that the Docker daemon is active and responding to API requests.

![](./Images/2.png)

### Step 3: Checked Docker version via REST API 
We retrieved Docker version details directly from the Docker API.

Command used:
```bash
curl --unix-socket /var/run/docker.sock http://localhost/version
```
This returned details like:

Docker Desktop version

Docker Engine version

API version

OS and architecture

![](./Images/3.png)

### Step 4: Listed running containers using REST API
We checked if any containers were running using the containers API endpoint.

Command used:
```bash
curl --unix-socket /var/run/docker.sock http://localhost/v1.51/containers/json
```
The output was an empty list, meaning no containers were running at that time.

![](./Images/4.png)