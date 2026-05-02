# Experiment 6: Docker Run vs Docker Compose

## Steps Taken

### Part 1: Basic Container Deployment

- **Using Docker Run**:
Deploying an Nginx container using the standard `docker run` command, manually configuring port mapping and bind mounts.
![Docker Run Nginx](<Screenshot 2026-05-02 at 12.07.31 AM.png>)

- **Using Docker Compose**:
Achieving the exact same Nginx deployment using a declarative `docker-compose.yml` file and `docker compose up -d`, simplifying the command line arguments.
![Docker Compose Nginx](<Screenshot 2026-05-02 at 12.11.50 AM.png>)

---

### Part 2: Multi-Container Applications (WordPress + MySQL)

- **Manual Networking with Docker Run**:
Deploying a MySQL database and a WordPress container separately, linking them manually through a shared custom network (`wp-net`) via individual `docker run` commands.
![Manual WordPress Deploy](<Screenshot 2026-05-02 at 12.17.50 AM.png>)

Verifying the manual deployment by successfully accessing the WordPress installation page.
![Verify Manual WordPress](<Screenshot 2026-05-02 at 12.56.23 AM.png>)

---

### Part 3: Introduction to Docker Compose Features

- **Simple Compose Service**:
Creating a `docker-compose.yml` for a basic Node.js application, defining ports, environment variables (`APP_ENV`, `DEBUG`), and restart policies.
![Simple Compose Config](<Screenshot 2026-05-02 at 1.25.34 AM.png>)

Starting and verifying the service using `docker-compose up`.
![Start Simple Compose](<Screenshot 2026-05-02 at 1.28.34 AM.png>)

- **Multi-Service Compose Application**:
Creating a multi-container `docker-compose.yml` combining a PostgreSQL database and a Python backend, establishing an explicit dependency utilizing `depends_on`.
![Multi-Service Config](<Screenshot 2026-05-02 at 1.40.22 AM.png>)

Running the multi-service application, observing real-time logs for both services, and gracefully stopping it.
![Run Multi-Service App](<Screenshot 2026-05-02 at 1.43.09 AM.png>)

Tearing down the entire environment, including removing the associated volumes, using `docker-compose down -v`.
![Teardown Multi-Service App](<Screenshot 2026-05-02 at 1.43.35 AM.png>)

- **Resource Limits in Compose**:
Enforcing strict CPU and Memory resource limits on a container natively within the `docker-compose.yml` definition using the `deploy.resources` directive.
![Resource Limits Compose](<Screenshot 2026-05-02 at 1.44.58 AM.png>)

---

### Part 4: Building Custom Images with Compose

- **Docker Compose Build Context**:
Using `docker compose up --build -d` to dynamically build a custom Node.js image directly from a local `Dockerfile` and `app.js` during the compose up process.
![Compose Build Process](<Screenshot 2026-05-02 at 1.55.58 AM.png>)

Confirming the successful build and deployment by accessing the custom Node.js web app displaying our lab output.
![Verify Custom Build](<Screenshot 2026-05-02 at 1.56.15 AM.png>)

---

### Part 5: Streamlining Complex Deployments (WordPress Compose Lab)

- **WordPress via Docker Compose**:
Replacing the tedious manual `docker run` setup with a single `docker-compose.yml` that handles WordPress, MySQL, networking, and volumes simultaneously.
![WordPress Compose Config](<Screenshot 2026-05-02 at 2.03.45 AM.png>)

Verifying the automated WordPress deployment via the browser interface.
![Verify WordPress Compose](<Screenshot 2026-05-02 at 2.08.13 AM.png>)

- **Automatic Volume Management**:
Observing that Docker Compose automatically provisions and prefixes named volumes (`wp-compose-lab_db_data`, `wp-compose-lab_wp_data`) for persistent storage based on the project directory.
![Compose Volume Management](<Screenshot 2026-05-02 at 2.10.42 AM.png>)

---

### Part 6: Scaling and Orchestration

- **Scaling Attempts in Compose**:
Attempting to scale the `wordpress` service using `docker-compose up --scale`. Observing the Docker warning caused by using static custom container names when attempting to replicate a service.
![Compose Scaling Warning](<Screenshot 2026-05-02 at 2.11.36 AM.png>)

- **Docker Swarm Integration**:
Initializing Docker Swarm (`docker swarm init`), deploying the compose file as a stack (`docker stack deploy`), and successfully scaling the WordPress service to 3 replicas (`docker service scale`) leveraging orchestration features.
![Docker Swarm Orchestration](<Screenshot 2026-05-02 at 2.13.28 AM.png>)
