# Experiment 6A
## Title: Comparison of Docker Run and Docker Compose

### PART A - THEORY

**1. Objective**
To understand the relationship between `docker run` and Docker Compose, and to compare their configuration syntax and use cases.

**2. Background Theory**

**2.1 Docker Run (Imperative Approach)**
The `docker run` command is used to create and start a container from an image. It requires explicit flags for:
* Port mapping (`-p`)
* Volume mounting (`-v`)
* Environment variables (`-e`)
* Network configuration (`--network`)
* Restart policies (`--restart`)
* Resource limits (`--memory`, `--cpus`)
* Container name (`--name`)

This approach is imperative, meaning you specify step-by-step instructions.

Example:
```bash
docker run -d \
  --name my-nginx \
  -p 8080:80 \
  -v ./html:/usr/share/nginx/html \
  -e NGINX_HOST=localhost \
  --restart unless-stopped \
  nginx:alpine
```

**2.2 Docker Compose (Declarative Approach)**
Docker Compose uses a YAML file (`docker-compose.yml`) to define services, networks, and volumes in a structured format. Instead of multiple `docker run` commands, a single command is used: `docker compose up -d`. Compose is declarative, meaning you define the desired state of the application.

Equivalent Compose file:
```yaml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    container_name: my-nginx
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    environment:
      NGINX_HOST: localhost
    restart: unless-stopped
```

**3. Mapping: Docker Run vs Docker Compose**
* `-p 8080:80` equivalent to `ports:`
* `-v host:container` equivalent to `volumes:`
* `-e KEY=value` equivalent to `environment:`
* `--name` equivalent to `container_name:`
* `--network` equivalent to `networks:`
* `--restart` equivalent to `restart:`
* `--memory` equivalent to `deploy.resources.limits.memory`
* `--cpus` equivalent to `deploy.resources.limits.cpus`

**4. Advantages of Docker Compose**
1. Simplifies multi-container applications
2. Provides reproducibility
3. Version controllable configuration
4. Unified lifecycle management
5. Supports service scaling (Example: `docker compose up --scale web=3`)

---

### PART B - PRACTICAL TASK

**Task 1: Single Container Comparison**

**Step 1: Run Nginx Using Docker Run**
Execute:  
![](/DevOps_Lab/Screenshots/6.1.png)  
Verify: `docker ps`  
![](/DevOps_Lab/Screenshots/6.2.png)
Access: `http://localhost:8081`  
![](/DevOps_Lab/Screenshots/6.3.png)   
Stop and remove container:  
![](/DevOps_Lab/Screenshots/6.4.png) 

**Step 2: Run Same Setup Using Docker Compose**
Create `docker-compose.yml`:  
![](/DevOps_Lab/Screenshots/6.5.png) 
Run: `docker compose up -d`  
![](/DevOps_Lab/Screenshots/6.6.png)  
Verify: `docker compose ps`   
Stop: `docker compose down`   

---

**Task 2: Multi-Container Application**
Objective: Deploy WordPress with MySQL using:
1. Docker Run (manual way)
2. Docker Compose (structured way)

**A. Using Docker Run**
1. Create network: `docker network create wp-net`
2. Run MySQL:  
![](/DevOps_Lab/Screenshots/6.7.png) 
3. Run WordPress:  
![](/DevOps_Lab/Screenshots/6.8.png)  

Test: `http://localhost:8082`
![](/DevOps_Lab/Screenshots/6.9.png)  

**B. Using Docker Compose**
Create `docker-compose.yml`:  
![](/DevOps_Lab/Screenshots/6.12.png) 
Run: `docker compose up -d`  
![](/DevOps_Lab/Screenshots/6.10.png) 
Stop: `docker compose down -v`  
![](/DevOps_Lab/Screenshots/6.11.png) 

---

### PART C - CONVERSION & BUILD-BASED TASKS

**Task 3: Convert Docker Run to Docker Compose**

**Problem 1: Basic Web Application**
Given Docker Run Command:
```bash
docker run -d \
  --name webapp \
  -p 5000:5000 \
  -e APP_ENV=production \
  -e DEBUG=false \
  --restart unless-stopped \
  node:18-alpine
```
Student Task:
1. Write an equivalent docker-compose.yml  
![](/DevOps_Lab/Screenshots/6.12.png) 
2. Ensure: Same container name, same port mapping, same environment variables, same restart policy.
3. Run using: `docker compose up -d`  
![](/DevOps_Lab/Screenshots/6.13(1).png) 
4. Verify using: `docker compose ps`

**Problem 2: Volume + Network Configuration**
Given Docker Run Commands:
```bash
docker network create app-net
docker run -d \
  --name postgres-db \
  --network app-net \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres:15
docker run -d \
  --name backend \
  --network app-net \
  -p 8000:8000 \
  -e DB_HOST=postgres-db \
  -e DB_USER=admin \
  -e DB_PASS=secret \
  python:3.11-slim
```
Student Task:
1. Create a single docker-compose.yml file that defines both services, creates named volume pgdata, creates custom network app-net, and uses depends_on.  
![](/DevOps_Lab/Screenshots/6.14.png)  

2. Bring up services using one command.  
![](/DevOps_Lab/Screenshots/6.15.png)  

3. Stop and remove everything properly.

**Task 4: Resource Limits Conversion**
Given Docker Run Command:
```bash
docker run -d \
  --name limited-app \
  -p 9000:9000 \
  --memory="256m" \
  --cpus="0.5" \
  --restart always \
  nginx:alpine
```
Student Task:
1. Convert this to Docker Compose.
2. Add resource limits using: deploy > resources > limits.  
![](/DevOps_Lab/Screenshots/6.16.png)  



---

### PART D - USING DOCKERFILE INSTEAD OF STANDARD IMAGE

**Task 5: Replace Standard Image with Dockerfile (Node App)**
Instead of using prebuilt images like `image: node:18-alpine`, students must create their own Dockerfile, build image using Compose, and run container from that build.

Scenario: You are given `docker run -d -p 3000:3000 node:18-alpine`. Now you must:
1. Create a simple Node.js app
2. Write a Dockerfile
3. Use Docker Compose build: option

**Step 1: Create app.js**  

![](/DevOps_Lab/Screenshots/6.17.png)  

**Step 2: Create Dockerfile**  

![](/DevOps_Lab/Screenshots/6.18.png)  

**Step 3: Create docker-compose.yml**  
![](/DevOps_Lab/Screenshots/6.19.png)  

Student Task:
1. Build and run using: `docker compose up --build -d`  
![](/DevOps_Lab/Screenshots/6.33.png) 
2. Verify in browser: `http://localhost:3000`  
![](/DevOps_Lab/Screenshots/6.20.png) 
3. Modify message in app.js, rebuild and observe changes.
4. Explain difference between `image:` and `build:`.n
Ans: `image:` is the specification of which image to use, whereas `build:` is used to tell which `Dockerfile` to use to build the image that will be used to run the conatiner.  

**Task 6: Multi-Stage Dockerfile with Compose**
Requirement: Create a simple Python FastAPI or Node production-ready app using:
* Multi-stage Dockerfile
* Smaller final image
* Use Compose to build it

Must:
1. Write multi-stage Dockerfile  
![](/DevOps_Lab/Screenshots/6.21.png) 
2. Use build: in Compose  
![](/DevOps_Lab/Screenshots/6.22.png)  

3. Add environment variables
4. Add volume mount for development mode
5. Compare image size: `docker images`

---

### Experiment 6 B
## Multi-Container Application using Docker Compose (WordPress + Database)

**1. Objective**
To deploy a multi-container application using Docker Compose, consisting of:
* WordPress (frontend + PHP)
* MySQL database (backend)

Also: Understand container networking & volumes, learn how to scale services, compare with Docker Swarm for production deployment.

**2. Prerequisites**
* Docker installed
* Docker Compose (comes with modern Docker)
* Basic understanding of containers

**3. Architecture Overview**
User (Browser) -> WordPress Container -> MySQL Container -> Persistent Volume (Database Storage)
* WordPress connects to MySQL using service name (DNS inside Docker network)
* Data is persisted using volumes

**Steps**

**Step 1: Create Project Directory**
```bash
mkdir wp-compose-lab
cd wp-compose-lab
```

**Step 2: Create docker-compose.yml**  
![](/DevOps_Lab/Screenshots/6.23.png) 

**Explanation of Key Sections**
* **services**: Defines containers (db -> MySQL database, wordpress -> application)
* **depends_on**: Ensures DB starts before WordPress
* **environment**: Used to configure DB credentials and connection
* **volumes**: Persist data even if containers are deleted
* **ports**: Exposes WordPress on http://localhost:8080

**Step 3: Start Application**
`docker-compose up -d`  
![](/DevOps_Lab/Screenshots/6.24.png) 
What happens: Images are pulled, Network is created, Containers are started, DNS-based service discovery enabled.

**Step 4: Verify Containers**
`docker ps` (Expected: wordpress_app, wordpress_db)  
![](/DevOps_Lab/Screenshots/6.25.png) 

**Step 5: Access WordPress**
Open browser: `http://localhost:8080` (Complete setup, enter title, user, password)  
![](/DevOps_Lab/Screenshots/6.26.png) 

**Step 6: Check Volumes**
`docker volume ls` (db_data -> database persistence, wp_data -> WordPress files)  
![](/DevOps_Lab/Screenshots/6.27.png) 

**Step 7: Stop Application**
`docker-compose down` (Containers removed, Volumes remain intact)
![](/DevOps_Lab/Screenshots/6.28.png)

**5. Scaling in Docker Compose**
Method 1: Scale WordPress Containers
`docker-compose up --scale wordpress=3` 
![](/DevOps_Lab/Screenshots/6.29.png) 
Result: 3 WordPress containers running.
Problem: All try to use same port (8080), no load balancing.
Solution: Use Reverse Proxy (Nginx). Add another service, then configure load balancing manually.
![](/DevOps_Lab/Screenshots/6.30.png) 

Limitations of Compose Scaling:
* No built-in load balancing
* No auto-healing
* Single host only
* Not production-ready for scaling

**6. Running Same Setup with Docker Swarm**
Step 1: Initialize Swarm: `docker swarm init`  
![](/DevOps_Lab/Screenshots/6.34.png) 
Step 2: Deploy Stack: `docker stack deploy -c docker-compose.yml wpstack`  
![](/DevOps_Lab/Screenshots/6.31.png) 
Step 3: Scale Service: `docker service scale wpstack_wordpress=3`  
![](/DevOps_Lab/Screenshots/6.32.png) 

**What Changes in Swarm?**
| Feature | Docker Compose | Docker Swarm |
| :--- | :--- | :--- |
| Scope | Single host | Multi-node cluster |
| Scaling | Manual | Built-in |
| Load balancing | No | Yes (internal LB) |
| Self-healing | No | Yes |
| Rolling updates | No | Yes |
| Networking | Basic | Overlay network |

**7. Benefits of Docker Swarm**
* Built-in load balancing
* Automatic container restart (self-healing)
* Horizontal scaling across nodes
* Rolling updates without downtime
* Service abstraction (not individual containers)

**8. Challenges / Limitations of Swarm**
* Less popular than Kubernetes
* Limited ecosystem
* Less flexible scheduling
* Fewer enterprise features

**9. Key Learning Outcomes**
* Multi-container apps require orchestration
* Docker Compose is ideal for: Development, Testing, Learning
* Docker Swarm is useful for: Simple production clusters, Easy scaling without Kubernetes complexity

**10. Conclusion**
This experiment demonstrated:
* How to deploy WordPress + MySQL using Docker Compose
* How containers communicate using internal networking
* Importance of volumes for persistence
* Scaling limitations of Compose
* Advantages of using Docker Swarm for production-ready deployments