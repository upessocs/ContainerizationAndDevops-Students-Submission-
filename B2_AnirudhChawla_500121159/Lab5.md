# **Experiment 5: Docker - Volumes, Environment Variables, Monitoring & Networks**

## **Part 1: Docker Volumes - Persistent Data Storage**

### **Lab 1: Understanding Data Persistence**

#### **The Problem: Container Data is Ephemeral**

```bash
docker run -it --name test-container ubuntu /bin/bash
echo "Hello World" > message.txt
cat message.txt
exit
docker stop test-container
docker rm test-container
docker run -it --name test-container ubuntu /bin/bash
cat message.txt
# cat: message.txt: No such file or directory
```

```bash
# Anonymous volume
docker run -d -v /app/data --name web1 nginx
docker volume ls
docker inspect web1 | grep -A 5 Mounts
```

![ ](/DevOps_Lab/Screenshots/5.1.png)

---

### **Lab 2: Volume Types**

#### **1. Named Volumes**

```bash
docker volume create mydata
docker run -d -v mydata:/app/data --name web2 nginx
docker volume ls
docker volume inspect mydata
docker run -d -v ~/myapp-data:/app/data --name web3 nginx
```

![ ](/DevOps_Lab/Screenshots/5.2.png)

#### **2. Bind Mounts (Host Directory)**

```bash
mkdir myapp-data
ls
docker run -d -v $(pwd)/myapp-data:/app/data --name web3 nginx
echo "From Host" > myapp-data/host-file.txt
docker exec -it web3 bash
ls /app/data
cat /app/data/host-file.txt
# From Host
exit
docker run -d \
  --name mysql-db \
  -v mysql-data:/var/lib/mysql \
```

![ ](/DevOps_Lab/Screenshots/5.3.png)

---

### **Lab 3: Practical Volume Examples**

#### **Example 1: Database with Persistent Storage**

```bash
# mysql:8.0 pulling layers
docker stop mysql-db
docker rm mysql-db
docker run -d \
  --name new-mysql \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0
mkdir ~/nginx-config
echo 'server {
    listen 80;
    server_name localhost;
    location / {
        return 200 "Hello from mounted config!";
    }
}' > ~/nginx-config/nginx.conf
docker run -d \
  --name nginx-custom \
  -p 8080:80 \
  -v ~/nginx-config/nginx.conf:/etc/nginx/conf.d/default.conf \
  nginx
```

![ ](/DevOps_Lab/Screenshots/5.4.png)

#### **Example 2: Web App with Configuration Files**

```bash
curl http://localhost:8080
# Hello from mounted config!
curl http://localhost:8080
# Hello from mounted config!
docker volume create app-volume
docker volume inspect app-volume
docker volume prune
# Deleted Volumes listed
# Total reclaimed space: 246.1MB
docker run -d \
  --name app1 \
  -e DATABASE_URL="postgres://user:pass@db:5432/mydb" \
  -e DEBUG="true" \
  -p 3000:3000 \
  nginx
# Error: container name "/app1" already in use
```

![ ](/DevOps_Lab/Screenshots/5.5.png)

---

## **Part 2: Environment Variables**

### **Lab 1: Setting Environment Variables**

#### **Method 1: Using -e flag**

```bash
docker rm -f app11
docker run -d \
  --name app11 \
  -e DATABASE_URL="postgres://user:pass@db:5432/mydb" \
  -e DEBUG="true" \
  -p 3005:3000 \
  nginx
docker ps
# Shows: app11, nginx-custom, new-mysql, web3, web2, web1, node-container
```

![ ](/DevOps_Lab/Screenshots/5.6.png)

```bash
docker exec -it app11 bash
env | grep DATABASE
# DATABASE_URL=postgres://user:pass@db:5432/mydb
env | grep DEBUG
# DEBUG=true
exit
docker rm -f app11
```

#### **Method 2: Using --env-file**

```bash
mkdir env-lab
cd env-lab
echo "DATABASE_HOST=localhost" > .env
echo "DATABASE_PORT=5432" >> .env
echo "API_KEY=secret123" >> .env
cat .env
# DATABASE_HOST=localhost
# DATABASE_PORT=5432
# API_KEY=secret123
docker run -d --name app2 --env-file .env nginx
# Error: name "/app2" already in use
docker run -d --name app22 --env-file .env nginx
docker exec -it app22 bash
echo $DATABASE_HOST
```

![ ](/DevOps_Lab/Screenshots/5.6(1).png)

```bash
# localhost
echo $DATABASE_PORT
# 5432
echo $API_KEY
# secret123
exit
docker rm -f app22
cd ..
mkdir flask-env-app
cd flask-env-app
echo "flask" > requirements.txt
nano app.py
nano Dockerfile
docker build -t flask-env-app .
# [+] Building 7.4s (10/10) FINISHED
```

![ ](/DevOps_Lab/Screenshots/5.7.png)

---

### **Lab 2: Flask App with Environment Variables**

#### **Dockerfile Build and Run**

```bash
# Build output - all 5 steps completing successfully
docker run -d \
  --name flask1 \
  -p 5001:5000 \
  -e DATABASE_HOST=mydb \
  -e DEBUG=true \
  -e API_KEY=supersecret \
  flask-env-app
# Error: port 0.0.0.0:5000 already allocated
docker rm -f flask1
docker run -d \
  --name flask1 \
  -p 5001:5000 \
  -e DATABASE_HOST=mydb \
  -e DEBUG=true \
  -e API_KEY=supersecret \
  flask-env-app
# Container started successfully
```

![ ](/DevOps_Lab/Screenshots/5.8.png)

### **Lab 3: Test Environment Variables**

```bash
# Browser: localhost:5001/config
# Output:
# {
#   "db_host": "mydb",
#   "debug": true,
#   "has_api_key": true
# }
```

![ ](/DevOps_Lab/Screenshots/5.9.png)

---

## **Part 3: Docker Monitoring**

### **Lab 1: `docker stats` - Real-time Container Metrics**

```bash
docker stats
# Live output:
#CONTAINER ID   NAME           CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
#8521cbe18941   flask1         0.28%     40.43MiB / 7.615GiB   0.52%     1.5kB / 777B      0B / 258kB        3
#45c915b7dacb   app1           0.00%     18.69MiB / 7.615GiB   0.24%     1.96kB / 126B     172kB / 12.3kB    25
#d4252783d510   nginx-custom   0.00%     19.02MiB / 7.615GiB   0.24%     3.21kB / 1.21kB   3.91MB / 4.1kB    25
#9dd09592720c   new-mysql      1.04%     349.2MiB / 7.615GiB   4.48%     2.25kB / 126B     36.1MB / 15.1MB   37
#d728b47aab0f   web3           0.00%     18.82MiB / 7.615GiB   0.24%     2.57kB / 126B     0B / 16.4kB       25
#b95ddfd64215   web2           0.00%     18.88MiB / 7.615GiB   0.24%     2.76kB / 126B     0B / 12.3kB       25
#85ef4033cc3b   web1           0.00%     18.62MiB / 7.615GiB   0.24%     3.17kB / 126B     0B / 12.3kB       25
```

![ ](/DevOps_Lab/Screenshots/5.10.png)

```bash
# docker stats --no-stream (all values show --)
docker stats --format json --no-stream
# JSON output per container with BlockIO, CPUPerc, Container, ID,
# MemPerc, MemUsage, Name, NetIO, PIDs fields
docker stats --no-stream --no-trunc
```

![ ](/DevOps_Lab/Screenshots/5.11.png)

---

### **Lab 2: `docker top` - Process Monitoring**

```bash
docker top flask1
#UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
#root                9434                9410                0                   14:19               ?                   00:00:00            python app.py
#root                9522                9434                0                   14:19               ?                   00:00:00            /usr/local/bin/python /app/app.py
#docker top flask1 -ef
#ps aux | grep docker
```

![ ](/DevOps_Lab/Screenshots/5.12.png)

```bash
# docker top monitor-test -ef continued
# showing same worker process list with full command lines
# UID, PID, PPID, C, STIME, TTY, TIME, CMD columns
# worker processes 3998 - 4004
```

---

### **Lab 3: `docker logs` - Application Logs**

```bash
# docker top -ef continued (worker processes 4002-4004)
ps aux | grep docker
# root   615  0.0  0.3  docker-desktop proxy --distro-name Ubuntu-22.04
# aswani 2149 0.0  0.0  grep --color=auto docker
docker logs flask1
# /docker-entrypoint.sh: configuration complete; ready for start up
# nginx/1.29.5 startup notices
# worker processes starting (30-45)
```


```bash
# docker logs continued:
# nginx worker processes (30-45) started
# HTTP access logs:
# 172.17.0.1 - [02/Mar/2026] "GET / HTTP/1.1" 200 615
# 172.17.0.1 - [02/Mar/2026] "GET /favicon.ico HTTP/1.1" 404 555
# [error] favicon.ico failed (2: No such file or directory)
docker logs --tail 100 flask1
```


```bash
docker logs -t flask1
# Logs with nanosecond timestamps:
# 2026-03-02T14:30:43.355838305Z /docker-entrypoint.sh: ...
# 2026-03-02T14:30:43.431310396Z [notice] nginx/1.29.5
# 2026-03-02T14:30:43.431372134Z [notice] built by gcc 14.2.0
# (all worker processes with full timestamps)
```


```bash
docker logs --since 5m flask1
# Shows all logs from last 5 minutes including startup + HTTP requests

docker logs -f --tail 50 -t flask1
# Combined: follow + last 50 lines + timestamps
```

![ ](/DevOps_Lab/Screenshots/5.13.png)
![ ](/DevOps_Lab/Screenshots/5.14.png)

```bash
# docker logs -f --tail 50 -t continued
# timestamped startup logs and HTTP access logs showing
```


---

### **Lab 4: Container Inspection**

```bash
docker inspect flask1
# Full JSON output:
# "Id": "24dbc24c9c690a8398cf8c1355e371086461a1055e45ef1a29e4c6d3127ce1f4"
# "Created": "2026-03-02T14:30:42.967030997Z"
# "State": {
#   "Status": "running",
#   "Running": true,
#   "Paused": false,
#   "Pid": 3944,
#   "ExitCode": 0
# }
# "Name": "/monitor-test"
# "Driver": "overlayfs"
```

![ ](/DevOps_Lab/Screenshots/5.15.png)

```bash
docker inspect --format='{{.Config.Env}}' flask1
# [PATH=... NGINX_VERSION=1.29.5 NJS_VERSION=0.9.5 ...]
docker inspect --format='{{.HostConfig.Memory}}' flask1
# 0
docker inspect --format='{{.HostConfig.NanoCpus}}' flask1
# 0
docker events
# (waiting, Ctrl+C to exit)
docker stop flask1
docker events
# (Ctrl+C)
docker events --filter 'type=container'
# Shows docker stats table with all running containers
```

![ ](/DevOps_Lab/Screenshots/5.15(1).png)

---

### **Lab 5: Practical Monitoring Script**

```bash
./monitor.sh
#=== Docker Monitoring Dashboard ===
#1. Running Containers:
#NAMES          STATUS       PORTS
#flask1         Up 2 hours   0.0.0.0:5001->3000/tcp, [::]:5001->3000/tcp
#app1           Up 3 hours   80/tcp, 0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp
#nginx-custom   Up 3 hours   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
#new-mysql      Up 3 hours   3306/tcp, 33060/tcp
#web3           Up 3 hours   80/tcp
#web2           Up 3 hours   80/tcp
#web1           Up 3 hours   80/tcp

#2. Resource Usage:
#NAME           CPU %     MEM USAGE / LIMIT     NET I/O           BLOCK I/O
#flask1         0.23%     40.43MiB / 7.615GiB   1.92kB / 777B     0B / 258kB
#app1           0.00%     18.69MiB / 7.615GiB   2.17kB / 126B     172kB / 12.3kB
#nginx-custom   0.00%     19.02MiB / 7.615GiB   3.42kB / 1.21kB   3.91MB / 4.1kB
#new-mysql      0.82%     349.2MiB / 7.615GiB   2.46kB / 126B     36.1MB / 15.1MB
#web3           0.00%     18.82MiB / 7.615GiB   2.71kB / 126B     0B / 16.4kB
#web2           0.00%     18.88MiB / 7.615GiB   2.97kB / 126B     0B / 12.3kB
#web1           0.00%     18.62MiB / 7.615GiB   3.31kB / 126B     0B / 12.3kB

#3. Recent Events:

#4. System Info:
#TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
#Images          5         5         3.059GB   0B (0%)
#Containers      9         7         811kB     16.38kB (2%)
#Local Volumes   4         3         210.3MB   0B (0%)
#Build Cache     13        0         1.599GB   28.67kB
```

![ ](/DevOps_Lab/Screenshots/5.16.png)

---

## **Part 4: Docker Networks**

### **Lab 1: Multi-Service Setup**

```bash
docker network ls
#NETWORK ID     NAME      DRIVER    SCOPE
#04c34ceeaedb   bridge    bridge    local
#032eba416aaf   host      host      local
#609c188dce0e   none      null      local
```

![ ](/DevOps_Lab/Screenshots/5.17.png)

---

### **Lab 2: Bridge Network**

```bash
docker run -d --name web1 --network my-network nginx
# Error: container name "/web1" already in use
docker ps -a | grep web1
docker rm -f web1
docker rm -f web2
docker run -d --name web1 --network my-network nginx
# Error: network my-network not found
docker network create my-network
```

![ ](/DevOps_Lab/Screenshots/5.18.png)
![ ](/DevOps_Lab/Screenshots/5.18(1).png) 

```bash
# curl output - web1 responding with nginx default page HTML
docker run -d --name host-app --network host nginx
curl http://localhost
# curl: (7) Failed to connect to localhost port 80 after 1 ms: Connection refused
```

![ ](/DevOps_Lab/Screenshots/5.18(2).png)

---

### **Lab 3: Host & None Network**

```bash
curl http://localhost
# Returns nginx default HTML page

docker run -d --name isolated-app --network none alpine sleep 3600
docker exec isolated-app ifconfig
# lo   Link encap:Local Loopback
#      inet addr:127.0.0.1  Mask:255.0.0.0
#      inet6 addr: ::1/128 Scope:Host
```

![ ](/DevOps_Lab/Screenshots/5.18(3).png)

```bash
# ifconfig continued:
# UP LOOPBACK RUNNING  MTU:65536  Metric:1
# RX packets:0 errors:0 TX packets:0 errors:0
# Only loopback - no external network access

docker network create app-network
docker network connect app-network web1
docker network disconnect app-network web1
docker network rm app-network
docker network prune
# Deleted Networks: my_overlay, my_ipvlan, 26compose_wordpress-network, mybridge
```

![ ](/DevOps_Lab/Screenshots/5.19.png)

---

### **Lab 4: Multi-Container App - Web + Database**

```bash
docker network create app-network
docker run -d \
  --name postgres-db \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres:15
# Pulling postgres:15 - all layers Pull complete
# Status: Downloaded newer image for postgres:15
```

![ ](/DevOps_Lab/Screenshots/5.20.png)

```bash
docker run -d \
  --name web-app \
  --network app-network \
  -p 8080:3000 \
  -e DATABASE_URL="postgres://postgres:secret@postgres-db:5432/mydb" \
  -e DATABASE_HOST="postgres-db" \
  node-app
# Error: pull access denied for node-app (image doesn't exist locally)

docker network inspect bridge
# "Name": "bridge"
# "Driver": "bridge"
# "EnableIPv4": true
# "IPAM": { "Config": [{ "Subnet": "172.17.0.0/16" }] }
```

![ ](/DevOps_Lab/Screenshots/5.20(1).png)

```bash
# bridge inspect continued:
# IPv4Address: "172.17.0.8/16"
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
# All container IDs listed and removed
```

![ ](/DevOps_Lab/Screenshots/5.20(2).png)

---

### **Lab 5: Port Publishing**

```bash
docker ps
# (empty)
docker run -d -p 80:8080 --name app1 nginx
docker run -d -p 8080 --name app2 nginx
docker ps
# app2: 0.0.0.0:56066->8080/tcp  (random port assigned)
# app1: 0.0.0.0:80->8080/tcp
docker run -d -p 8082:80 -p 8443:443 --name app3 nginx
docker run -d -p 127.0.0.1:8085:80 --name app4 nginx
docker network create myapp-network
docker network ls
#NETWORK ID     NAME            DRIVER    SCOPE
#bb849a0c6540   app-network     bridge    local
#04c34ceeaedb   bridge          bridge    local
#032eba416aaf   host            host      local
#46b5dc6ed097   my-network      bridge    local
#5ed511317523   myapp-network   bridge    local
#609c188dce0e   none            null      local
```

![ ](/DevOps_Lab/Screenshots/5.21.png)

---

## **Part 5: Complete Real-World Example**

### **Flask + PostgreSQL + Redis Setup**

```bash
docker run -d \
  --name redis \
  --network myapp-network \
  -v redis-data:/data \
  redis:7-alpine
# Pulling redis:7-alpine - all layers Pull complete
# Status: Downloaded newer image for redis:7-alpine
mkdir app
echo "print('Flask app placeholder')" > app/app.py
echo "SECRET_KEY=supersecretkey" > .env.production
echo "APP_ENV=production" >> .env.production
cat .env.production
# SECRET_KEY=supersecretkey
# APP_ENV=production
docker build -t flask-app:latest .
# [+] Building 61.0s (7/7) FINISHED
```

![ ](/DevOps_Lab/Screenshots/5.22.png)

### **Monitoring All Services**

```bash
# docker stats (no-stream) - postgres, redis, flask-app all showing --
# Ctrl+C
docker ps
#CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS              PORTS                                                                                NAMES
#dbaf2bba6251   redis:7-alpine   "docker-entrypoint.s…"   About a minute ago   Up About a minute   6379/tcp                                                                             redis
#d8fe0179fc5e   nginx            "/docker-entrypoint.…"   3 minutes ago        Up 3 minutes        127.0.0.1:8085->80/tcp                                                               app4
#d8648c4982db   nginx            "/docker-entrypoint.…"   3 minutes ago        Up 3 minutes        0.0.0.0:8082->80/tcp, [::]:8082->80/tcp, 0.0.0.0:8443->443/tcp, [::]:8443->443/tcp   app3
#8d603b7e1478   nginx            "/docker-entrypoint.…"   3 minutes ago        Up 3 minutes        80/tcp, 0.0.0.0:32768->8080/tcp, [::]:32768->8080/tcp                                app2
#216d15b176b7   nginx            "/docker-entrypoint.…"   3 minutes ago        Up 3 minutes        80/tcp, 0.0.0.0:80->8080/tcp, [::]:80->8080/tcp 
```

![ ](/DevOps_Lab/Screenshots/5.22(1).png)

---

## **Key Takeaways**

1. **Volumes** persist data beyond container lifecycle
2. **Environment variables** configure containers dynamically
3. **Monitoring commands** help debug and optimize containers
4. **Networks** enable secure container communication
5. **Always use named volumes** for production data
6. **Custom networks** provide better isolation and DNS
7. **Monitor resource usage** to prevent issues
8. **Use .env files** for sensitive configuration