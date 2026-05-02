# Experiment 11 — Orchestration using Docker Compose & Docker Swarm

## Objective
To understand container orchestration and deploy a multi-container application using Docker Swarm.  
The experiment demonstrates scaling, load balancing, and self-healing capabilities compared with Docker Compose.

---

# Theory

## What is Container Orchestration?

Container orchestration is the **automatic management of containers**.

It handles tasks such as:

- scaling containers
- restarting failed containers
- distributing traffic across containers
- running services across multiple machines

An analogy is a **restaurant manager** who ensures enough staff are working, replaces unavailable staff, and distributes customers efficiently. 

---

# Progression of Container Management Tools

```
docker run → Docker Compose → Docker Swarm → Kubernetes
```

| Tool | Purpose |
|-----|------|
| docker run | run a single container |
| Docker Compose | run multiple containers together |
| Docker Swarm | orchestrate containers across nodes |
| Kubernetes | advanced orchestration platform |

This lab focuses on **moving from Compose to Swarm orchestration**. 

---

# Prerequisites

- Docker installed
- Docker Swarm enabled
- WordPress + MySQL Compose file from Experiment 6

---

# Docker Compose File

```yaml
version: '3.9'

services:

  db:
    image: mysql:5.7
    container_name: wordpress_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
    volumes:
      - db_data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    container_name: wordpress_app
    depends_on:
      - db
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wp_data:/var/www/html

volumes:
  db_data:
  wp_data:
```

---

# Task 1 — Stop Existing Containers

First ensure no containers are running.

```bash
docker compose down -v
docker ps
```

Expected result: no containers running.

---

# Task 2 — Initialize Docker Swarm

Enable Swarm mode:

![](/DevOps_Lab/Screenshots/11.1.png)  

This command:

- enables swarm mode
- makes the current machine the **manager node**
- generates a join token for worker nodes

Verify swarm status:

![](/DevOps_Lab/Screenshots/11.2.png)  

Expected output shows the node status as **Ready / Leader**. :contentReference[oaicite:4]{index=4}

---

# Task 3 — Deploy Application as a Stack

Deploy the compose file as a **stack**.

![](/DevOps_Lab/Screenshots/11.3.png)  

Explanation:

| Command | Meaning |
|---|---|
| docker stack deploy | deploy application in swarm |
| -c docker-compose.yml | specify compose file |
| wpstack | stack name |

Behind the scenes Swarm:

1. reads the compose file  
2. creates services  
3. manages containers automatically.

---

# Task 4 — Verify Deployment

List services:

![](/DevOps_Lab/Screenshots/11.4.png)  

Example output:

```
ID NAME MODE REPLICAS IMAGE
xxxx wpstack_db replicated 1/1 mysql:5.7
xxxx wpstack_wordpress replicated 1/1 wordpress:latest
```

Inspect running tasks:

![](/DevOps_Lab/Screenshots/11.5.png)  

Check containers:

![](/DevOps_Lab/Screenshots/11.6.png)  

Containers now have names like:

```
wpstack_wordpress.1.xxxx
wpstack_db.1.xxxx
```

Swarm now **manages containers automatically**. 

---

# Task 5 — Access the Application

Open browser:

```
http://localhost:8080
```
![](/DevOps_Lab/Screenshots/11.14.png)  

You should see the **WordPress setup page**.

Even though Swarm manages the containers, the application behaves the same.

---

# Task 6 — Scale the Application

Scale WordPress service from **1 to 3 replicas**.

![](/DevOps_Lab/Screenshots/11.7.png)  

Verify scaling:  

![](/DevOps_Lab/Screenshots/11.8.png)  
![](/DevOps_Lab/Screenshots/11.9.png)  
![](/DevOps_Lab/Screenshots/11.10.png)  

Now **three WordPress containers run simultaneously**. 

---

# Load Balancing

Even with multiple containers, users still access:

```
http://localhost:8080
```

Swarm creates an **internal load balancer** that distributes traffic across all containers automatically.

---

# Task 7 — Test Self-Healing

Swarm automatically replaces failed containers.

Find a WordPress container:

```bash
docker ps | grep wordpress
```

Kill it:

```bash
docker kill <container-id>
```

Check service tasks:
![](/DevOps_Lab/Screenshots/11.11.png)  

Swarm detects the failure and **creates a replacement container automatically**. 

---

# Task 8 — Remove the Stack

Clean up all services:

![](/DevOps_Lab/Screenshots/11.12.png)  

Verify removal:

![](/DevOps_Lab/Screenshots/11.13.png)  

Containers should be removed.

---

# Compose vs Swarm

| Feature | Docker Compose | Docker Swarm |
|---|---|---|
| Scope | single host | multi-node cluster |
| Scaling | basic | built-in service scaling |
| Load balancing | no | yes |
| Self-healing | no | yes |
| Rolling updates | no | yes |
| Service discovery | container names | DNS + VIP |

Compose is best for **development**, while Swarm supports **production orchestration**.
---

# Observations

1. The same Compose YAML file can be reused in Swarm.
2. In Swarm, you manage **services instead of containers**.
3. Swarm resolves port conflicts using an internal load balancer.

---

# Learning Outcome Questions

1. Why is Docker Compose not sufficient for production environments?
2. What does `docker stack deploy` do differently from `docker compose up`?
3. How does Swarm provide self-healing?
4. What happens if a container managed by Swarm is killed?
5. Can the same Compose file be used for development and production?

---

# Conclusion

This experiment demonstrated container orchestration using Docker Swarm.  
A multi-container WordPress application was deployed using a Compose file, scaled to multiple replicas, and tested for self-healing capabilities. Swarm provides built-in load balancing, automatic recovery, and cluster management, making it more suitable for production environment