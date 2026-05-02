# Experiment 9: Ansible

## Steps Taken

### Part 1: SSH Key Generation and Verification

- **Generating SSH Keys**:
Using `ssh-keygen` to generate a secure public/private RSA key pair (`id_rsa`) on the control node. This enables secure, passwordless authentication to our target servers.
![Generate SSH Keys](<Screenshot 2026-05-02 at 4.44.07 AM.png>)

- **Manual SSH Connection**:
Connecting to a target container manually using `ssh root@localhost -p 2222` to verify basic networking connectivity and accept the initial host key fingerprint.
![Manual SSH Connect](<Screenshot 2026-05-02 at 4.52.43 AM.png>)

- **SSH Key Authentication**:
Exiting the initial session and verifying passwordless login by explicitly passing our generated private key (`ssh -i ~/.ssh/id_rsa`).
![SSH Key Authentication](<Screenshot 2026-05-02 at 4.53.11 AM.png>)

---

### Part 2: Provisioning Target Servers

- **Automated Container Creation**:
Using a bash `for` loop to rapidly provision 4 separate Ubuntu server containers (`server1` to `server4`). The loop maps their internal SSH ports to local host ports (2201-2204) and outputs their internal IP addresses.
![Provision Server Containers](<Screenshot 2026-05-02 at 4.55.17 AM.png>)

---

### Part 3: Ansible Configuration

- **Creating the Inventory File**:
Dynamically building an Ansible `inventory.ini` file utilizing shell redirection. The inventory defines the target servers, their specific SSH ports, and a `[servers:vars]` section that specifies the SSH user (`root`) and the private key file to use.
![Create Inventory File](<Screenshot 2026-05-02 at 5.01.03 AM.png>)

- **Host Key Verification**:
Manually connecting to `server3` via SSH to demonstrate the manual process of accepting a host's fingerprint into the `known_hosts` file.
![Manual Host Key Verification](<Screenshot 2026-05-02 at 5.02.52 AM.png>)

---

### Part 4: Running Ansible Commands

- **Testing Connectivity (Ad-Hoc Ping)**:
Running the Ansible ad-hoc `ping` module (`ansible all -i inventory.ini -m ping`). `server3` succeeds because we manually verified its host key in the previous step, while the others fail due to strict host key checking.
![Ansible Ping Failed Verification](<Screenshot 2026-05-02 at 5.05.31 AM.png>)

- **Successful Ping Across All Nodes**:
After bypassing or resolving the host key verification step for the remaining servers, a subsequent ping command successfully reaches and authenticates against all 4 nodes in the inventory.
![Ansible Ping Success](<Screenshot 2026-05-02 at 5.05.47 AM.png>)

---

### Part 5: Executing Ansible Playbooks

- **Playbook Execution and Verification**:
Executing a declarative Ansible playbook that runs tasks across all managed nodes (e.g., creating a file). The `PLAY RECAP` shows successful changes. 
We then verify the playbook's success by running an ad-hoc command (`ansible all ... -m command -a "cat /root/ansible_test.txt"`) to confirm that the file was correctly configured by Ansible on every single server.
![Ansible Playbook Execution](<Screenshot 2026-05-02 at 5.09.06 AM.png>)
