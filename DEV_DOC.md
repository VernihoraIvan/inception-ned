# Developer Documentation

This document outlines the technical details required for developers to set up, build, and maintain the Inception project structure.

## Environment Setup

### Prerequisites
Before running the project, ensure the host environment has the following installed:
- **Docker Engine** (with Docker Compose support)
- **Make** (build automation tool)
- **Git**

### Configuration
The project relies on environment variables and secrets files.

1.  **Environment Variables**:
    Located in `srcs/.env`. This file defines non-sensitive configuration defaults (e.g., domain name, user IDs).

2.  **Secrets**:
    Located in the `secrets/` directory. Create the following text files with your desired passwords before building if they do not exist:
    - `secrets/mariadb_password.txt`
    - `secrets/mariadb_root_password.txt`
    - `secrets/wp_admin_password.txt`
    - `secrets/wp_password.txt`

    *Note: Ensure these files do not contain newlines or extra whitespace/characters.*

## Building and Launching

The workspace includes a `Makefile` to streamline Docker Compose commands.

### Commands
- **Build and Run**:
  ```bash
  make
  # or explicitly
  make up
  ```
  *This ensures data directories exist, builds images from `srcs/requirements/*/Dockerfile`, and starts containers.*

- **Build Only**:
  ```bash
  make build
  ```
  *Rebuilds the Docker images without starting the containers.*

- **Stop and Remove**:
  ```bash
  make down
  ```
  *Stops containers and removes network resources.*

- **View Logs**:
  ```bash
  make logs
  ```
  *Follows log output from all services.*

## Container and Volume Management

### Container Logic
The stack is orchestrated via `srcs/docker-compose.yml`.
- **nginx**: Depends on `wordpress`. Mounts volumes to serve static assets.
- **wordpress**: Depends on `mariadb`. Runs PHP-FPM.
- **mariadb**: Initialized with a custom script.

### Data Persistence
Data is persisted on the host machine using **Bind Mounts**. This ensures data remains available even if containers are destroyed.

**Storage Locations**:
- **WordPress Files**: `/home/iverniho/data/wordpress`
  - Mapped to `/var/www/html` inside the WordPress and NGINX containers.
- **Database Files**: `/home/iverniho/data/mariadb`
  - Mapped to `/var/lib/mysql` inside the MariaDB container.

**Persistence**:
Because these are bind mounts to the host filesystem (specifically under `/home/iverniho/data/`), the data survives `docker compose down`. To perform a complete "factory reset" and wipe all data, you must manually delete the contents of these directories on the host machine (requires root/sudo privileges due to container file ownership).
