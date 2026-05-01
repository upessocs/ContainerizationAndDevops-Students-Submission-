# Multistage Dockerfiles - Best Practices (Size, Speed & Security)

**Date:** 10.02.26


---

## Aim

To understand **Multistage Dockerfiles** and implement them on **Windows (Powershell + VS Code)**

- Smaller in size
- Faster to build and deploy 
- More secure for production

--- 

## Why Use Multistage Dockerfiles?

Multistage Dockerfiles allow multiple `FROM` statements in one Dockerfile.
Each stage has its own purpose:

- **Build stage** → contains compilers/tools  
- **Runtime stage** → contains only final executable or application 

This helps seperate development and production environments.

---

## Key Benefits

### 1. Reduced Image Size
- Build tools are excluded from final image
- Intermediate artificats removed
- Source code not exposed

### 2. Improved Build Speed
- Better caching of dependencies
- Smaller images pull/push faster

### 3. Enhanced Security
- Minimal packages in production
- Reduced attack surfaces
- No compilers/build tools inside runtime

### 4. Clean Separation of Concerns
- Development stage ≠ Production stage  
- Reproducible builds 

---

## `scratch` Image

`scratch` is an empty base image:

- 0 bytes
- No shell, no libraries
- Used for statically compiled binaries

Perfect for minimal and secure containers.

---
## PART A: C Program Mutilstage Dockerfile (Scratch)

### Step 1: Create Folder
```bash
mkdir c-program
cd c-program
```
![](./Images/1.png)
### Step 2: Create hello.c
```bash
cat <<EOF > hello.c
#include <stdio.h>

int main() {
    printf("Hello from Multistage Dockerfile!\n");
    return 0;
}
EOF
```
![](./Images/2.png)

### Step 3: Create Dockerfile
```bash
# Stage 1: Build Stage
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y gcc
COPY hello.c .
RUN gcc -static -o hello hello.c

# Stage 2: Runtime Stage

FROM scratch
COPY --from=builder /hello /hello
CMD ["/hello"]
```
![](./Images/3.png)
### Step 4: Build Image
```bash
docker build -t c-multistage .
```
![](./Images/4.png)

### Step 5: Run Container
```bash
docker run c-multistage
```
![](./Images/5.png)
## Result 

Final image size: ~1.29MB
![](./Images/6.png)


## PART B: Java Multistage Dockerfile (Maven → JRE)

### Step 1: Create Folder 
```bash
mkdir java-program
cd java-program
mkdir -p src/main/java
```
![](./Images/7.png)

### Step 2: Create App.java
```bash
cat <<EOF > src/main/java/App.java
public class App {
    public static void main(String[] args) {
        System.out.println("Hello Java Multistage Docker!");
    }
}
EOF
```
![](./Images/8.png)

### Step 3: Create pom.xml
```bash
cat <<EOF > pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>multistage-demo</artifactId>
  <version>1.0</version>
</project>
EOF
```
![](./Images/9.png)

### Step 4: Create Multistage Dockerfile
```bash
# Stage 1: Build Stage
FROM maven:3.8-openjdk-11 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Runtime Stage

FROM eclipse-temurin:11-jre

WORKDIR /app
COPY --from=builder /app/target/multistage-demo-1.0.jar app.jar

# Security: Run as non-root user

RUN useradd -m myuser
USER myuser

CMD ["java", "-jar", "app.jar"]
```
![](./Images/10.png)

### Step 5: Build Image
```bash
docker build -t java-multistage .
```

### Step 6: Run Container
```bash
docker run java-multistage
```
![](./Images/11.png)

## Result

Final image size: ~404 MB
![](./Images/12.png)

## 📊 Performance Comparison

| Aspect            | Single Stage  | Multistage |
|------------------|--------------|------------|
| Java Image Size   | ~1.11 GB      | 433 MB     |
| C Image Size      | ~150 MB       | 968 KB     |
| Security          | Low           | High       |
| Deployment Speed  | Slow          | Fast       |


## Conclusion

Multistage Dockerfiles are essential for production-ready containers because they:

Reduce image size

Improve performance

Increase security

Separate build and runtime environments

They are highly recommended for microservices and CI/CD deployments.