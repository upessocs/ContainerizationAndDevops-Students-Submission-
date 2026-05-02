# Experiment 10 — SonarQube Static Code Analysis Lab

## Objective
To understand and perform static code analysis using SonarQube by:
- Running a SonarQube server using Docker
- Scanning a Java project using Sonar Scanner (via Maven plugin)
- Viewing detected bugs, vulnerabilities, and code smells in the dashboard

---

# Theory

## Problem Statement
Code bugs and security vulnerabilities are often discovered too late in the development cycle. Manual reviews are slow and hard to scale.

Static code analysis tools like **SonarQube** automatically analyze source code without executing it.

---

# What is SonarQube?

SonarQube is an open-source platform used for **continuous inspection of code quality**.

It detects:

- Bugs
- Security vulnerabilities
- Code smells
- Code duplication
- Technical debt
- Test coverage

---

# SonarQube Architecture

SonarQube has two main components.

## SonarQube Server

Responsible for:

- storing results
- applying analysis rules
- enforcing quality gates
- providing a dashboard

Runs at:

```
http://localhost:9000
```

---

## Sonar Scanner

Scanner:

- reads source code
- gathers project metadata
- sends results to the server

The **server performs the real analysis**, not the scanner.

---

# Architecture Flow

```
Source Code
     │
     ▼
Sonar Scanner
     │
     ▼
SonarQube Server
     │
     ▼
PostgreSQL Database
     │
     ▼
Web Dashboard
```

---

# Step 1 — Start SonarQube Server

Create `docker-compose.yml`

![](/DevOps_Lab/Screenshots/10.1.png)

Start containers:

![](/DevOps_Lab/Screenshots/10.2.png)

Check logs:

![](/DevOps_Lab/Screenshots/10.3.png)

Open dashboard:

```
http://localhost:9000
```

Login:

```
admin / admin
```

---

# Step 2 — Create Sample Java App

Create project structure:

![](/DevOps_Lab/Screenshots/10.4.png)

Create `Calculator.java`

![](/DevOps_Lab/Screenshots/10.5.png)

---

# Step 3 — Create Maven Config

Create `pom.xml`

![](/DevOps_Lab/Screenshots/10.6.png)

---

# Step 4 — Generate Token

Open dashboard → profile → **My Account → Security**

Generate token:

![](/DevOps_Lab/Screenshots/10.7.png)

---

# Step 5 — Run Scan

```
cd sample-java-app
```

Run scanner:

![](/DevOps_Lab/Screenshots/10.8.png)  
![](/DevOps_Lab/Screenshots/10.9.png)

Process:

1. Maven compiles project
2. Scanner collects code
3. Sends analysis to server
4. Server evaluates rules
5. Results stored in PostgreSQL

---

# Step 6 — View Results

Open:
![](/DevOps_Lab/Screenshots/10.10.png)  
![](/DevOps_Lab/Screenshots/10.11.png)  
![](/DevOps_Lab/Screenshots/10.12.png)  
![](/DevOps_Lab/Screenshots/10.13.png)


You will see:

- Bugs
- Vulnerabilities
- Code Smells
- Duplication
- Technical Debt
- Quality Gate

---

# Results

Detected issues include:

- Division by zero bug
- SQL injection vulnerability
- Unused variable
- Duplicate methods
- Null pointer risk
- Empty catch block

---

# Conclusion

In this experiment, SonarQube was deployed using Docker with PostgreSQL.  
A Java project was analyzed using the Maven Sonar Scanner plugin, and issues such as bugs, vulnerabilities, and code smells were detected and visualized through the SonarQube dashboard.