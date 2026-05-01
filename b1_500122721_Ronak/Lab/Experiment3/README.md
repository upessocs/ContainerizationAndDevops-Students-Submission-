# Experiment 3: Docker Deploy NGINX Using Different Base Images and Comparing Image Layers

---

## Part 1: Deploy NGINX Using Official Image (Recommended Approach)

---

### Step 1: Pull the Image

```bash
docker pull nginx:latest
```
![Pull Image](./Images/1.png)

**Step 2: Run the Container**
```bash
docker run -d --name nginx-official -p 8080:80 nginx 
```
![Run Container](./Images/2.png)

**Step 3: Verify**
```bash
curl http://localhost:8080
```
![Verify](./Images/3.png)


You should see the **NGINX welcome page**.



**Key observations**
```bash
docker images nginx 
```
![List Images](./Images/4.png)


* Image is **pre-optimized**
* Minimal configuration required
* Uses Debian-based OS internally

## Part 2: Custom NGINX Using Ubuntu Base Image

**Step 1: Create Dockerfile**

```Dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y ngnix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```


**Step 2: Build Image**

```bash
docker build -t nginx-ubuntu .
```
![Build from Ubuntu Image](./Images/5.png)


**Step 3: Run Container**

```bash
docker run -d --name nginx-ubuntu -p 8081:80 nginx-ubuntu
```
![Run Container](./Images/6.png)


**Observations**

```bash
docker images nginx-ubuntu
```
![List Ubuntu-Images](./Images/7.png)

* Much **larger image size**
* More layers
* Full OS utilities available

## Part 3: Custom NGINX Using Alpine Base Image

*Step 1: Create Dockerfile**

```Dockerfile
FROM alpine:latest

RUN apk add --no-cache nginx 

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**Step 2: Build Image**

```bash 
docker build -t nginx-alpine .
```
![Build Apline-Image](./Images/8.png)


**Step 3: Run Container**

```bash
docker run -d --name nginx-alpine -p 8082:80 nginx-alpine 
```
![List Apline-Images](./Images/9.png)


**Observations**

```bash
docker images nginx-alpine
```
![List Apline-Images](./Images/10.png)


* Extremely **small image**
* Fewer packages
* Faster pull and startup time

## Part 4: Image Size and Layer Comparison

**Compare Sizes**

```bash
docker images | grep nginx
```
![List All nginx Images](./Images/11.png)


_Typical result (approx):_

| Image Type   | Size      |
| ------------ | --------- |
| nginx:latest | 237 MB    |
| nginx-ubuntu | 199 MB    |
| nginx-alpine | 16 MB     |



**Inspect Layers**

```bash
docker history nginx
docker history nginx-ubuntu
docker history nginx-apline
```
![Inspect](./Images/12.png)
![Inspect](./Images/13.png)
![Inspect](./Images/14.png)


**Observations:**

* Ubuntu has many filesystem layers
* Alpine has minimal layers
* Official NGINX image is optimized but heavier than alpine

## Part 5: Functional Tasks Using NGINX

**Task 1: Serve Custom HTML Page**

```bash
mkdir html
echo "<h1>Ronak Agarwal 500122721</h1>" > html/index.html
```
![Result](./Images/15.png)

_Run:_

```bash
docker run -d \
  -p 8083:80 \
  -v $(pwd)/html:/usr/share/nginx/html \
  nginx
```
![Command](./Images/16.png)


**Task 2: Reverse Proxy (Conceptual)**

_NGINX can:_

* Forward traffic to backend services
* Load balance multiple containers
* Terminate SSL

_Example use cases:_

* Frontend for microservices
* API gateway
* Static file server

## Part 6: Comparison Summary

**Image Comparison Table**

| Feature          | Official NGINX | Ubuntu + NGINX | Alpine + NGINX |
| ---------------- | -------------- | -------------- | -------------- |
| Image Size       | Medium         | Large          | Very Small     |
| Ease of Use      | Very Easy      | Medium         | Medium         |
| Startup Time     | Fast           | Slow           | Very Fast      |
| Debugging Tools  | Limited        | Excellent      | Minimal        |
| Security Surface | Medium         | Large          | Small          |
| Production Ready | Yes            | Rarely         | Yes            |


## Part 7: When to use what 

**Use Official NGINX Image When:**

* Production deployment
* Standard web hosting
* Reverse proxy / load balancer

**Use Ubuntu-Based Image When:**

* Learning Linux + NGINX internals
* Heavy debugging needed
* Custom system-level dependencies

**Use Alpine-Based Image When:**

* Microservices
* CI/CD pipelines
* Cloud and Kubernetes workloads
