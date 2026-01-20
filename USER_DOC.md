# User Documentation

This guide provides simple instructions for end-users and administrators to manage and interact with the Inception service stack.

## Services Overview

This project provides a complete web infrastructure stack consisting of:
1.  **WordPress**: A popular Content Management System (CMS) for building websites.
2.  **MariaDB**: A reliable database server that stores all WordPress content and user data.
3.  **NGINX**: A high-performance web server acting as the entry point, handling secure (HTTPS) connections.

## Starting and Stopping the Project

The project is managed via a `Makefile` for simplicity.

### Start the Project
To start all services, open a terminal in the project root and run:
```bash
make
```
*This will build necessary components and start the application in the background.*

### Stop the Project
To stop the services and remove the containers:
```bash
make down
```

## Accessing the Website

Once the project is running:

### Public Website
- Open your web browser.
- Navigate to: **`https://iverniho.42.fr`**
- *Note: You may see a security warning because the SSL certificate is self-signed. This is expected in a development environment; you can proceed safely.*

### Administration Panel
- Navigate to: **`https://iverniho.42.fr/wp-admin`**
- Log in using the administrative credentials (see below).

## Managing Credentials

Passwords and sensitive information are **not** stored in plain text configuration files. They are managed via **Docker Secrets**.

You can find the actual password values in the `secrets/` directory at the root of the project:
- **WordPress Admin Password**: `secrets/wp_admin_password.txt`
- **WordPress User Password**: `secrets/wp_password.txt`
- **Database Root Password**: `secrets/mariadb_root_password.txt`
- **Database User Password**: `secrets/mariadb_password.txt`

## Checking Service Status

To verify that all services are running correctly:

1.  **View Running Containers**:
    Run the following command to see the status of the containers:
    ```bash
    docker ps
    ```
    You should see three containers listed: `nginx`, `wordpress`, and `mariadb`, all with a status of "Up".

2.  **Check Logs**:
    If something isn't working, you can view the live logs of the services:
    ```bash
    make logs
    ```
    Press `Ctrl+C` to exit the log view.
