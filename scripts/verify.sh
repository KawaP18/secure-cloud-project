#!/bin/bash
docker ps
curl -k -I https://localhost:8443/app
sudo ufo status verbose
sudo cscli metrics
