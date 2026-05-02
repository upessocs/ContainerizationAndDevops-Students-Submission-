# Experiment 10: SonarQube

## Steps Taken

### Part 1: Provisioning SonarQube Server

- **Starting SonarQube and Database**:
Created a dedicated Docker network (`sonarqube-lab`). Then, deployed a PostgreSQL database container and the main SonarQube server container (`sonarqube:lts-community`), linking them together with environment variables for database credentials.
![Provisioning SonarQube](<Screenshot 2026-04-18 at 8.49.15 AM.png>)

### Part 2: Project Creation in Web UI

- **Initial Project Setup**:
Accessed the SonarQube web interface (`localhost:9000`) after initialization and navigated to the project creation screen, selecting the "Manually" option to begin defining a new project.
![SonarQube Web UI](<Screenshot 2026-04-18 at 8.53.09 AM.png>)

### Part 3: Running Code Analysis

- **Preparing the Sonar Scanner**:
Pulled and deployed the official SonarQube Scanner CLI container (`sonarsource/sonar-scanner-cli:latest`). We mounted our local `sample-java-app` code into the scanner container and attached it to the same `sonarqube-lab` network.
![Sonar Scanner Preparation](<Screenshot 2026-04-18 at 8.53.38 AM.png>)

- **Configuring and Executing the Scan**:
Dynamically generated a `sonar-project.properties` configuration file defining the project key, name, sources, and Java binaries path. Then, we executed the scan inside the scanner container using `docker exec`, passing the Sonar token securely via an environment variable.
![Executing Code Scan](<Screenshot 2026-04-18 at 8.54.22 AM.png>)

### Part 4: Reviewing Analysis Results

- **Quality Gate Overview**:
Returned to the SonarQube web interface to review the project dashboard. The overview successfully displayed a "Passed" Quality Gate, indicating overall reliability and security metrics.
![Quality Gate Passed](<Screenshot 2026-04-18 at 9.28.33 AM.png>)

- **Detailed Issue Review**:
Drilled down into the "Issues" tab to review specific code smells and warnings identified by the static analyzer (e.g., unused imports, unused local variables, and high method complexity), providing actionable feedback for code improvement.
![Reviewing Issues](<Screenshot 2026-04-18 at 9.28.39 AM.png>)
