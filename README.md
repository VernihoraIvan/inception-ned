*This project has been created as part of the 42 curriculum by iverniho.*

# Inception

## Description
This project aims to broaden the knowledge of system administration by using Docker. The goal is to set up a small infrastructure composed of different services complying with specific rules. The project involves building a multi-container application using Docker Compose, consisting of NGINX, MariaDB, and WordPress, each running in their own isolated container continuously.

## Instructions

### Prerequisites
- Docker Engine
- Docker Compose
- Make

### Installation and Execution
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd inception
   ```

2. Build and start the containers using the Makefile:
   ```bash
   make
   ```
   Or explicitly:
   ```bash
   make up
   ```
   This command will:
   - Create the necessary data directories (`/home/iverniho/data/wordpress` and `/home/iverniho/data/mariadb`).
   - Build the Docker images for NGINX, MariaDB, and WordPress.
   - Start the services in detached mode.

3. Access the application:
   - Open your browser and navigate to `https://iverniho.42.fr` (ensure your `/etc/hosts` maps this domain to localhost/127.0.0.1).

4. Stop the containers:
   ```bash
   make down
   ```

5. View logs:
   ```bash
   make logs
   ```

## Project Description
This project uses **Docker** to containerize the application services. Instead of installing NGINX, MariaDB, and WordPress directly on the host machine or a single virtual machine, each service runs in its own lightweight, isolated container based on Alpine Linux (or Debian as per requirements).

**Design Choices:**
- **Docker Compose:** Used to orchestrate the multi-container application, defining services, networks, and volumes in a single YAML file (`srcs/docker-compose.yml`).
- **Custom Dockerfiles:** Each service is built from a custom `Dockerfile` located in `srcs/requirements/`, ensuring a tailored environment for each component.
- **TLS/SSL:** NGINX is configured to serve the site over HTTPS using a self-signed certificate.

### Technical Comparisons

#### Virtual Machines vs Docker
- **Virtual Machines (VMs)**: Virtualize the hardware. Each VM runs a full operating system (kernel + user space) on top of a hypervisor. This provides strong isolation but consumes significant resources (RAM, CPU, disk) and takes longer to boot.
- **Docker (Containers)**: Virtualize the operating system. Containers share the host system's kernel but have their own isolated user space (filesystem, processes, network). This makes them extremely lightweight, fast to start, and efficient in resource usage compared to VMs.

#### Secrets vs Environment Variables
- **Environment Variables**: passing sensitive data (passwords, API keys) via environment variables (e.g., in `.env` files or `environment` keys in docker-compose) is common but insecure. The values can be easily viewed via `docker inspect` or process listings.
- **Docker Secrets**: A more secure way to handle sensitive data. Secrets are encrypted at rest (in Swarm) and mounted as files into the container (e.g., `/run/secrets/my_secret`). This prevents credentials from accidentally leaking in logs or environment dumps. In this project, passwords for MariaDB and WordPress are managed via secrets.

#### Docker Network vs Host Network
- **Docker Network (Bridge)**: The default network driver. Containers are placed on a private internal network. They can communicate with each other using service names (DNS) but are isolated from the host network. Ports must be explicitly published (e.g., `443:443`) to be accessible from outside.
- **Host Network**: The container removes network isolation and shares the host's networking namespace directly. The container uses the host's IP and ports directly. While faster (no NAT), it exposes the container completely and can cause port conflicts.

#### Docker Volumes vs Bind Mounts
- **Docker Volumes**: Managed by Docker (usually stored in `/var/lib/docker/volumes`). They are the preferred mechanism for persisting data as they are easier to back up, migrate, and manage using Docker CLI commands. They are isolated from the host's direct filesystem structure.
- **Bind Mounts**: Map a specific file or directory on the host machine to a path inside the container. We use bind mounts in this project (mapped to `/home/iverniho/data/`) to store database and website files. This allows data to persist after containers are removed and makes it easy to inspect or modify data directly from the host.

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Code Reference](https://developer.wordpress.org/reference/)
