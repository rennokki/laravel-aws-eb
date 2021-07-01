#!/bin/sh

# This file will run restarts on specific services like NGINX.
# During postdeploy, we make sure to restart the services to 
#take in consideration the new custom config

sudo systemctl restart nginx.service