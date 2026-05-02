# Experiment 5: Docker - Volumes, Environment Variables, Monitoring & Networks

---

## Table of Contents

1. [Part 1: Docker Volumes](#part-1-docker-volumes---persistent-data-storage)
2. [Part 2: Environment Variables](#part-2-environment-variables)
3. [Part 3: Docker Monitoring](#part-3-docker-monitoring)
4. [Part 4: Docker Networks](#part-4-docker-networks)
5. [Part 5: Complete Real-World Example](#part-5-complete-real-world-example)
6. [Quick Reference Cheatsheet](#quick-reference-cheatsheet)
7. [Practice Exercises](#practice-exercises)
8. [Conclusion](#key-takeaways)
9. [Additional Resources](#additional-resources)

---

## Part 1: Docker Volumes - Persistent Data Storage

### Lab 1: Understanding Data Persistence

**The Problem: Container Data is Ephemeral**
```bash
# Create a container that writes data
docker run -it --name test-container ubuntu /bin/bash

# Inside container:
echo "Hello World" > /data/message.txt
cat /data/message.txt  # Shows "Hello World"
exit

# Restart container
docker start test-container
docker exec test-container cat /data/message.txt
# ERROR: File doesn't exist! Data was lost.
```

**Solution: Docker Volumes**

![Data Persistence Concept](../Asset/Lab_5/P1-1.png)
![Persistence Example](../Asset/Lab_5/P1-2.png)

---

### Lab 2: Volume Types

#### 1. Anonymous Volumes
```bash
# Create anonymous volume (auto-generated name)
docker run -d -v /app/data --name web1 nginx

# Check volume
docker volume ls
# Shows: anonymous volume with random hash

# Inspect container to see volume mount
docker inspect web1 | grep -A 5 Mounts
```
![Anonymous Volume](../Asset/Lab_5/P1-3.png)

#### 2. Named Volumes
```bash
# Create named volume
docker volume create mydata

# Use named volume
docker run -d -v mydata:/app/data --name web2 nginx

# List volumes
docker volume ls
# Shows: mydata

# Inspect volume
docker volume inspect mydata
```
![Named Volume](../Asset/Lab_5/P1-4.png)
![Volume Inspection](../Asset/Lab_5/P1-5.png)

#### 3. Bind Mounts (Host Directory)
```bash
# Create directory on host
mkdir ~/myapp-data

# Mount host directory to container
docker run -d -v ~/myapp-data:/app/data --name web3 nginx

# Add file on host
echo "From Host" > ~/myapp-data/host-file.txt

# Check in container
docker exec web3 cat /app/data/host-file.txt
# Shows: From Host
```

---

### Lab 3: Practical Volume Examples

#### Example 1: Database with Persistent Storage
```bash
# MySQL with named volume
docker run -d \
  --name mysql-db \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0

# Check data persists
docker stop mysql-db
docker rm mysql-db

# New container with same volume
docker run -d \
  --name new-mysql \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0
# Data is preserved!
```
![MySQL Volume Persistence](../Asset/Lab_5/P1-6.png)

#### Example 2: Web App with Configuration Files
```bash
# Create config directory
mkdir ~/nginx-config

# Create nginx config file
echo 'server {
    listen 80;
    server_name localhost;
    location / {
        return 200 "Hello from mounted config!";
    }
}' > ~/nginx-config/nginx.conf

# Run nginx with config bind mount
docker run -d \
  --name nginx-custom \
  -p 8080:80 \
  -v ~/nginx-config/nginx.conf:/etc/nginx/conf.d/default.conf \
  nginx

# Test
curl http://localhost:8080
```
![Nginx Custom Config](../Asset/Lab_5/P1-7.png)

---

### Lab 4: Volume Management Commands
```bash
# List all volumes
docker volume ls

# Create a volume
docker volume create app-volume

# Inspect volume details
docker volume inspect app-volume

# Remove unused volumes
docker volume prune

# Remove specific volume
docker volume rm volume-name

# Copy files to/from volume
docker cp local-file.txt container-name:/path/in/volume
```
![Volume Commands](../Asset/Lab_5/P1-8.png)
![Volume Cleanup](../Asset/Lab_5/P1-9.png)

---

## Part 2: Environment Variables

### Lab 1: Setting Environment Variables

**Method 1: Using -e flag**
```bash
# Single variable
docker run -d \
  --name app1 \
  -e DATABASE_URL="postgres://user:pass@db:5432/mydb" \
  -e DEBUG="true" \
  -p 3000:3000 \
  my-node-app
```
![Env Var -e Flag](../Asset/Lab_5/P2-L1-1.png)

**Method 2: Using --env-file**
```bash
# Create .env file
echo "DATABASE_HOST=localhost" > .env
echo "DATABASE_PORT=5432" >> .env
echo "API_KEY=secret123" >> .env

# Use env file
docker run -d \
  --env-file .env \
  --name app2 \
  my-app
```
![Env File Integration](../Asset/Lab_5/P2-L1-2.png)

---

### Lab 2: Environment Variables in Applications

**Python Flask Example**
```python
import os
from flask import Flask

app = Flask(__name__)

# Read environment variables
db_host = os.environ.get('DATABASE_HOST', 'localhost')
debug_mode = os.environ.get('DEBUG', 'false').lower() == 'true'

@app.route('/config')
def config():
    return {
        'db_host': db_host,
        'debug': debug_mode
    }

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
```

**Dockerfile with Environment Variables**
```dockerfile
FROM python:3.9-slim
ENV PORT=5000
ENV DEBUG=false
EXPOSE 5000
CMD ["python", "app.py"]
```
![App Env Configuration](../Asset/Lab_5/P2-L2-1.png)
![App Env Test](../Asset/Lab_5/P2-L2-2.png)

---

## Part 3: Docker Monitoring

### Lab 1: Basic Monitoring Commands
```bash
# Live stats for all containers
docker stats

# JSON output
docker stats --format json --no-stream
```
![Docker Stats](../Asset/Lab_5/P3-L1-1.png)
![Docker Stats JSON](../Asset/Lab_5/P3-L1-2.png)

### Lab 2: docker top - Process Monitoring
```bash
# View processes in container
docker top container-name
```
![Docker Top](../Asset/Lab_5/P3-L2-1.png)

### Lab 3: docker logs - Application Logs
```bash
# Follow logs (like tail -f)
docker logs -f container-name
```
![Docker Logs](../Asset/Lab_5/P3-L3-1.png)

### Lab 4: Container Inspection
```bash
# Detailed container info
docker inspect container-name
```
![Container Inspection 1](../Asset/Lab_5/P3-L4-1.png)
![Container Inspection 2](../Asset/Lab_5/P3-L4-2.png)
![Container Inspection 3](../Asset/Lab_5/P3-L4-3.png)
![Container Inspection 4](../Asset/Lab_5/P3-L4-4.png)

### Lab 5: Events Monitoring
```bash
# Monitor Docker events in real-time
docker events
```
![Docker Events 1](../Asset/Lab_5/P3-L5-1.png)
![Docker Events 2](../Asset/Lab_5/P3-L5-2.png)
![Docker Events 3](../Asset/Lab_5/P3-L5-3.png)

---

## Part 4: Docker Networks

### Lab 1: Understanding Docker Network Types
```bash
# List Networks
docker network ls
```

### Lab 2: Network Types Explained
1. **Bridge (Default)**: Isolated internal network.
2. **Host**: Shares host network stack.
3. **None**: No network interfaces.
4. **Overlay**: Multi-host communication (Swarm).

---

## Part 5: Complete Real-World Example

```bash
# 1. Create network
docker network create myapp-network

# 2. Start database with volume
docker run -d --name postgres --network myapp-network -e POSTGRES_PASSWORD=mysecretpassword -v postgres-data:/var/lib/postgresql/data postgres:15

# 3. Start Flask app
docker run -d --name flask-app --network myapp-network -p 5000:5000 -v $(pwd)/app:/app -e DATABASE_URL="postgresql://postgres:mysecretpassword@postgres:5432/mydatabase" flask-app:latest
```

---

## Quick Reference Cheatsheet

| Category | Commands |
| :--- | :--- |
| **Volumes** | `docker volume create`, `docker run -v`, `docker volume ls` |
| **Env Vars** | `docker run -e`, `docker run --env-file` |
| **Monitoring** | `docker stats`, `docker logs -f`, `docker top`, `docker events` |
| **Networks** | `docker network create`, `docker network connect` |

---

## Practice Exercises
1. **Database Backup**: Practice copying data from a volume using `docker cp`.
2. **Multi-Service Setup**: Create a web app and DB on a custom network.
3. **Log Analysis**: Use `docker logs --tail` to filter output.

---

## Key Takeaways
- **Volumes** persist data beyond container lifecycle.
- **Environment Variables** configure containers dynamically.
- **Monitoring** helps debug and optimize resource usage.
- **Networks** enable secure container communication.

---

## Additional Resources
- [Manage data in Docker](https://docs.docker.com/storage/)
- [Docker Networking Overview](https://docs.docker.com/network/)
- [Docker Statistics Reference](https://docs.docker.com/engine/reference/commandline/stats/)
