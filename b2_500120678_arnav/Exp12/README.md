# Experiment 12: Study and Analyse Container Orchestration using Kubernetes

## Steps Taken

### Part 1: Cluster Setup and Initial Deployment

- **Deploying WordPress to Kubernetes**:
After initializing the local `minikube` cluster, we deployed the WordPress application using a declarative Kubernetes manifest (`wordpress-deployment.yaml`) via the `kubectl apply -f` command.
- **Monitoring Pod Creation**:
We verified the deployment by checking the status of the cluster's pods using `kubectl get pods`. The output displayed the initial replicas in the `ContainerCreating` state as Kubernetes scheduled the workloads and pulled the required container images.
![Initial Deployment](<Screenshot 2026-05-02 at 4.33.36 AM.png>)

---

### Part 2: Scaling and Self-Healing

- **Scaling the Deployment**:
We reviewed the cluster services using `kubectl get svc` and subsequently scaled the WordPress deployment horizontally to 4 replicas using the imperative `kubectl scale deployment` command. We confirmed the orchestrator's response by listing the pods again.
- **Testing Self-Healing Capabilities**:
To demonstrate Kubernetes' built-in self-healing and reconciliation loops, we intentionally terminated one of the running pods using `kubectl delete pod`. Running `kubectl get pods` immediately afterward showed that the Deployment controller automatically detected the missing pod and provisioned a new replacement, successfully maintaining the declared desired state of 4 running replicas.
![Scaling and Self-Healing](<Screenshot 2026-05-02 at 4.35.13 AM.png>)
