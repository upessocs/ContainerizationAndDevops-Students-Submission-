# Experiment 5: Docker- Volumes, Environment variables, Monitoring and Networks

## Steps Taken

### Part 1: Docker Volumes

- **Interactive Container and File System**:
Created a file inside an interactive container to understand ephemeral storage and verify how files are lost when a container is removed.
![Interactive Container](<Screenshot 2026-05-01 at 7.26.31 PM.png>)

- **Anonymous Volumes**:
Running a container with an anonymous volume and verifying its creation using the `docker volume ls` command.
![Anonymous Volume](<Screenshot 2026-05-01 at 7.36.21 PM.png>)

Inspecting the container to view the destination and source path of the newly created anonymous volume.
![Inspect Anonymous Volume](<Screenshot 2026-05-01 at 7.39.29 PM.png>)

- **Named Volumes**:
Creating a named volume (`mydata`) and directly mounting it to an Nginx container to provide recognizable persistent storage.
![Named Volume](<Screenshot 2026-05-01 at 7.40.09 PM.png>)

- **Bind Mounts**:
Using bind mounts to attach a directory from the host system to the container, demonstrating how changes sync between the host and container in real-time.
![Bind Mount](<Screenshot 2026-05-01 at 7.41.06 PM.png>)

- **Persistent Database Storage**:
Running a MySQL container with a named volume (`mysql-data`) to ensure database records persist beyond the container's lifecycle.
![MySQL Named Volume](<Screenshot 2026-05-01 at 7.47.24 PM.png>)

After stopping and removing the initial database container, we launched a new one using the same named volume to successfully confirm data persistence.
![Database Persistence](<Screenshot 2026-05-01 at 7.52.28 PM.png>)

- **Mounting Configuration Files**:
Bind mounting an Nginx configuration file (`nginx.conf`) from the host system into the container's `/etc/nginx/conf.d` directory to customize server behavior.
![Mount Config File](<Screenshot 2026-05-01 at 7.54.18 PM.png>)

- **Volume Management**:
Managing Docker volumes through commands like `create`, `ls`, `inspect`, and `prune` to keep the host environment clean.
![Volume Management](<Screenshot 2026-05-01 at 7.58.20 PM.png>)

---

### Part 2: Environment Variables

- **Passing Environment Variables Directly**:
Injecting environment variables (`DATABASE_URL`, `DEBUG`) directly via the command line using the `-e` flag.
![Env Variables Command Line](<Screenshot 2026-05-01 at 8.06.25 PM.png>)

- **Using Environment Files (.env)**:
Loading multiple environment variables efficiently from a `.env` file using the `--env-file` flag.
![Env File](<Screenshot 2026-05-01 at 8.07.29 PM.png>)

- **Building Apps with Environment Variables**:
Building a custom Flask application from a `Dockerfile` that will utilize our environment variables.
![Build Flask App](<Screenshot 2026-05-01 at 10.26.54 PM.png>)

Running the Flask application and using `docker exec ... env` to verify the injected environment variables are present within the running container.
![Exec Env](<Screenshot 2026-05-01 at 10.29.19 PM.png>)

---

### Part 3: Monitoring Containers

- **Resource Usage Stats**:
Using `docker stats` to monitor real-time CPU, memory usage, and network I/O for active containers.
![Docker Stats](<Screenshot 2026-05-01 at 10.31.17 PM.png>)

- **Viewing Logs**:
Using `docker logs` to check the application-level logs and server output for our Flask container.
![Docker Logs](<Screenshot 2026-05-01 at 10.31.57 PM.png>)

- **Inspecting Container State**:
Using `docker inspect` to get detailed JSON output regarding the container's internal state, configuration, and execution path.
![Docker Inspect](<Screenshot 2026-05-01 at 10.32.58 PM.png>)

- **Custom Monitoring Script**:
Creating and executing a custom bash script (`monitor.sh`) to build a simplified Docker monitoring dashboard summarizing running containers and resource usage.
![Custom Monitor Script](<Screenshot 2026-05-01 at 10.38.17 PM.png>)

---

### Part 4: Docker Networks

- **Listing Networks**:
Viewing all available Docker networks (including defaults like bridge, host, none) using `docker network ls`.
![Network LS](<Screenshot 2026-05-01 at 10.43.57 PM.png>)

- **Network Management**:
Creating custom bridge networks with specific subnets (`app-network`, `my-subnet`), connecting containers, and removing networks.
![Network Management](<Screenshot 2026-05-01 at 10.46.27 PM.png>)

- **Running Containers on Custom Networks**:
Launching a multi-container application setup on a custom `myapp-network` alongside bind mounts and `.env.production` files.
![Run on Custom Network](<Screenshot 2026-05-01 at 11.22.00 PM.png>)

- **Monitoring Networked Containers**:
Monitoring the real-time resource utilization of multiple inter-connected containers (`postgres`, `redis`, `flask-app1`).
![Monitor Networked Containers](<Screenshot 2026-05-01 at 11.22.17 PM.png>)

- **Inspecting Custom Networks**:
Inspecting the custom `myapp-network` to view subnet details and identify all connected container endpoints.
![Inspect Network](<Screenshot 2026-05-01 at 11.23.19 PM.png>)
