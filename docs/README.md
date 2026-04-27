# Secure Private Cloud Hosting Environment

## Overview

This project implements a secure private cloud hosting environment using Docker and Docker Compose on an Ubuntu Server VirtualBox virtual machine.

The aim of the project is to demonstrate a small secure hosting platform for an organisation that needs a web-facing service and supporting internal services. The solution applies Zero Trust and Defence in Depth principles by combining reverse proxying, HTTPS, network segmentation, identity management, host firewall rules, intrusion detection, logging, monitoring, and security testing.

The environment is not deployed to a public cloud provider. It runs locally inside a student-built Ubuntu Server VM.

## Main Technologies Used

- Ubuntu Server LTS
- Docker
- Docker Compose
- Traefik
- Nginx
- PostgreSQL
- Keycloak
- Dozzle
- Prometheus
- Grafana
- CrowdSec
- UFW
- Trivy
- OWASP ZAP
- Cloudflare Tunnel

## Repository Structure

The repository is organised as follows:

/
docker-compose.yml
traefik/
keycloak/
apps/
scripts/
backup.sh
restore.sh
verify.sh
docs/
README.md
report.pdf
security/
trivy-or-grype/
zap/
evidence/
screenshots/
logs/

The docker-compose.yml file defines the container stack. The traefik folder contains reverse proxy and TLS configuration. The scripts folder contains helper scripts for backup, restore, and verification. The security folder contains scan outputs. The evidence folder stores screenshots and logs used in the report.

## System Architecture

The system is built using several containers, each with a specific role.

Traefik is used as the reverse proxy and central ingress point. It receives external traffic and routes requests to the correct internal service based on path rules.

Nginx is used as the web-facing application. It is accessed through the /app route.

PostgreSQL is used as the internal database. It is not exposed directly to the host or to external users.

Keycloak provides identity and access management. It is used to demonstrate authentication and role-based access control.

Dozzle provides container log visibility.

Prometheus collects metrics from configured targets.

Grafana provides a visualisation layer for metrics.

CrowdSec provides intrusion detection by analysing logs for suspicious behaviour.

Cloudflare Tunnel provides external access to the application without opening additional inbound ports on the VM.

## Network Design

The solution uses two main Docker networks:

frontend_net:
This network is used for services that need to be reachable through Traefik, such as the web app, Keycloak, Dozzle, Prometheus, and Grafana.

backend_net:
This network is used for internal services such as PostgreSQL. Backend services are not directly reachable from outside the Docker environment.

This design supports network segmentation and reduces unnecessary lateral movement between services.

## Security Design

The system applies several security controls.

Traefik is the only central ingress point. This reduces the attack surface because services do not expose their own public ports.

HTTPS is enforced through Traefik. This protects traffic in transit.

The database is placed on the backend network and is not directly exposed. This demonstrates least exposure.

Keycloak provides IAM and role-based access control. Access is based on identity rather than network location.

UFW is enabled on the host to restrict inbound traffic.

CrowdSec is used as an intrusion detection component.

Dozzle provides container log visibility.

Prometheus and Grafana provide monitoring evidence.

Cloudflare Tunnel allows external access without directly exposing services to the internet.

## Setup Instructions

Start from the project directory:

cd ~/secure-cloud

Start the environment:

docker compose up -d

Check running containers:

docker ps

Stop the environment:

docker compose down

Restart the environment:

docker compose down
docker compose up -d

## Accessing Services

Application:

https://localhost:8443/app

Keycloak:

https://localhost:8443/auth

Dozzle logs:

https://localhost:8443/logs

Grafana:

https://localhost:8443/grafana

Prometheus is used internally for metrics collection.

## Keycloak Credentials

Admin login:

Username: admin
Password: AdminPass123!

Keycloak is used to demonstrate identity and access management. Users and roles can be configured in the admin console to demonstrate RBAC.

## Grafana Credentials

Default login:

Username: admin
Password: admin

If Grafana asks for a password change, use a new lab password and record it securely.

## Verification Commands

Check containers:

docker ps

Check HTTPS app access:

curl -k -I https://localhost:8443/app

Check database is not exposed from the host:

nc -vz 127.0.0.1 5432 || true

Check the app can resolve the database internally:

docker exec app getent hosts db

Check UFW:

sudo ufw status verbose

Check CrowdSec:

sudo systemctl status crowdsec
sudo cscli metrics

Check Prometheus from inside Grafana:

docker exec grafana wget -qO- http://prometheus:9090/api/v1/query?query=up

## Scripts

The scripts folder contains:

backup.sh
Creates a simple backup of important configuration files.

restore.sh
Restores configuration files from a previous backup folder.

verify.sh
Runs basic checks to confirm the stack is running and security controls are active.

Run the verification script:

./scripts/verify.sh

Run the backup script:

./scripts/backup.sh

Run the restore script:

./scripts/restore.sh backups/backup-folder-name

## Security Testing

Trivy was used for image scanning.

Example command:

trivy image nginx:alpine

The Trivy output is stored in:

security/trivy-or-grype/

OWASP ZAP was used to run a baseline scan against the application endpoint.

Target:

https://localhost:8443/app

ZAP output is stored in:

security/zap/

The main findings were missing HTTP security headers such as CSP and HSTS. These are accepted lab risks and would be fixed in production through secure Traefik middleware and response header configuration.

## Logging and Monitoring

Dozzle is used to view live container logs.

Prometheus is used to collect metrics.

Grafana is deployed as the visualisation layer.

The up query is used to show target status. Some targets may show as down in the lab if they are configured but not exposing metrics. This is noted as a limitation.

## Cloudflare Tunnel

Cloudflare Tunnel is used to demonstrate secure external access.

First get the app container IP:

docker inspect app --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{println}}{{end}}'

Then run:

cloudflared tunnel --url http://APP-IP

The generated trycloudflare.com link can be opened in a browser to access the application externally.

## Evidence Collected

Evidence is stored in:

evidence/screenshots/
evidence/logs/

Screenshots should include:

- docker ps showing running containers
- HTTPS app access
- Keycloak IAM or roles
- Dozzle logs
- Grafana or Prometheus monitoring evidence
- UFW firewall status
- CrowdSec metrics
- Trivy scan results
- ZAP scan results
- Cloudflare Tunnel external access

## Limitations

This is a lab environment and has some limitations.

Self-signed certificates are used instead of a trusted certificate authority.

The database is not replicated.

RBAC is basic and would need to be expanded in a real enterprise.

Some monitoring targets may show as down if services do not expose metrics.

CrowdSec is used mainly for detection evidence and is not fully integrated with automated blocking in this lab.

In production, these limitations would be addressed using trusted certificates, high availability, stronger IAM policies, automated alerting, and SIEM integration.

## Conclusion

This project demonstrates a secure container-based private cloud hosting environment. It uses layered security controls including Traefik, HTTPS, Docker network segmentation, Keycloak IAM, Dozzle logging, Prometheus and Grafana monitoring, UFW firewalling, CrowdSec intrusion detection, Trivy scanning, OWASP ZAP testing, and Cloudflare Tunnel external access.

The solution demonstrates Defence in Depth and Zero Trust principles within a Docker-based Ubuntu Server lab environment.
