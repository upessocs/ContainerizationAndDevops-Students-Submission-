# Experiment: Overlay Network across Multiple VMs

## Steps Taken

### Part 1: Provisioning the Infrastructure

- **Creating Virtual Machines**:
We utilized `multipass` to provision three separate Ubuntu virtual machines (`manager1`, `worker1`, and `worker2`). This simulated a multi-host environment necessary for testing cross-node communication.
![Provisioning VMs](<Screenshot 2026-03-28 at 10.35.42 AM.png>)

- **Installing Docker Engine**:
We executed a remote bash command via `multipass exec` to run the official Docker installation script on each of the newly created virtual machines, ensuring they all had the necessary container runtime.
![Installing Docker](<Screenshot 2026-03-28 at 10.35.50 AM.png>)

---

### Part 2: Swarm and Network Configuration

- **Initializing the Cluster and Network**:
We initialized a Docker Swarm on `manager1` and joined the other two VMs as worker nodes. Once the cluster was formed, we created a new multi-host network named `my-overlay` using the `overlay` driver, making it `--attachable` so standalone containers could connect to it.
![Creating Overlay Network](<Screenshot 2026-03-28 at 10.43.24 AM.png>)

---

### Part 3: Testing Connectivity

- **Validating Cross-Host Communication**:
To prove the overlay network successfully bridged the separate VMs, we deployed container `c1` on `manager1` and container `c2` on `worker1`, explicitly attaching both to the `my-overlay` network. We then executed a `ping` command from inside `c1` targeting `c2` by name. The successful ICMP replies demonstrated flawless cross-VM network resolution and connectivity provided by the Docker overlay network.
![Testing Connectivity](<Screenshot 2026-03-28 at 10.43.42 AM.png>)
