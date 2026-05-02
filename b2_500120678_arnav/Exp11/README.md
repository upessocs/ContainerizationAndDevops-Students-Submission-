# Experiment 11: Orchestration using Docker Compose and Docker Swarm

## Steps Taken

### Part 1: Swarm Initialization

- **Initializing Docker Swarm**:
Transitioning the local Docker engine from standalone single-host mode into Swarm mode using `docker swarm init`. The initialization establishes the current node as the Leader/Manager of the swarm, verified via the `docker node ls` command.
![Swarm Initialization](<Screenshot 2026-05-02 at 3.04.06 AM.png>)

---

### Part 2: Deploying a Stack

- **Deploying with Docker Stack**:
Deploying a multi-tier application (WordPress and MySQL) directly from an existing `docker-compose.yml` configuration using the `docker stack deploy` command. Note how the Swarm orchestrator automatically handles network creation and safely ignores standalone Compose options (like static container names) that are incompatible with dynamic scaling.
![Docker Stack Deploy](<Screenshot 2026-05-02 at 3.05.37 AM.png>)

- **Verifying Deployment**:
Confirming that the services are actively running and properly routing traffic by accessing the WordPress installation wizard in a web browser on the configured port.
![Verify WordPress Deployment](<Screenshot 2026-05-02 at 3.06.36 AM.png>)

---

### Part 3: Scaling Services

- **Scaling Service Replicas**:
Dynamically scaling the `wpstack_wordpress` frontend service horizontally to 3 replicas. The Swarm orchestrator distributes these tasks, verified by observing the updated replica count via `docker service ls` and the multiple individual containers via `docker ps`.
![Scaling Services](<Screenshot 2026-05-02 at 3.07.26 AM.png>)

---

### Part 4: High Availability and Teardown

- **Task History and Healing**:
Inspecting the granular task history of the scaled service using `docker service ps`. This demonstrates Docker Swarm's self-healing capabilities: when a task unexpectedly failed (indicated by a non-zero exit code 137), the orchestrator automatically spawned a replacement task to ensure the desired replica count was maintained.
![Service Task History](<Screenshot 2026-05-02 at 3.09.33 AM.png>)

- **Stack Removal**:
Executing a clean teardown of the entire application environment using `docker stack rm`. This command systematically removes all services and the dynamically generated overlay networks associated with the stack, leaving the environment clean.
![Stack Teardown](<Screenshot 2026-05-02 at 3.10.26 AM.png>)
