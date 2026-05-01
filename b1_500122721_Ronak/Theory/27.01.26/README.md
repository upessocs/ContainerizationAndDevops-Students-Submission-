# 27-01-2026

## Topic: Docker Installation on Windows

### Objective
To install Docker on Windows and verify the installation using terminal commands.

---

## Steps Performed

### 1. Installing Docker Desktop for Windows

Docker Desktop was downloaded for Windows from the official Docker website.

**Download Link:**  
https://www.docker.com/products/docker-desktop/

After downloading:

- Run the installer (`Docker Desktop Installer.exe`)
- Follow the installation wizard
- Ensure **WSL 2** is enabled when prompted
- Restart the system if required

---

### 2. Starting Docker Desktop

After installation:

- Open **Docker Desktop**
- Wait until Docker shows **“Docker is running”** status

---

### 3. Verifying Docker Installation

Open **Command Prompt** or **PowerShell** and run:

```bash
docker --version
