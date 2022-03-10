#!/bin/bash

# Restart Supervisor workers

# During deployment, some of the workers might have
# SPAWN ERR errors, so it's better to restart them.

# At this point in time, the whole app
# has already been deployed.

sudo supervisorctl restart all
