#!/bin/bash

# Spot Termination notice handler.
# See https://aws.amazon.com/blogs/compute/best-practices-for-handling-ec2-spot-instance-interruptions/

# If you are using spot instances, you might want to handle termination notices.
# This script will continuously poll the EC2 Metadata Endpoint every 5 seconds,
# and if it detects a termination notice, it can run your arbitrary code, like safely
# shutting down processes, for example.

# To active this script, you shall uncomment the .platform/files/supervisor.ini process
# that will keep this script alive throughout the instance lifecycle until its termination.

TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

while sleep 5; do

  HTTP_CODE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s -w %{http_code} -o /dev/null http://169.254.169.254/latest/meta-data/spot/instance-action)

  if [[ "$HTTP_CODE" -eq 401 ]] ; then

    # Refreshing the authentication token...
    TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 30"`

  elif [[ "$HTTP_CODE" -eq 200 ]] ; then

    # Here, the instance knows it will be interrupted.
    # Run your code.

  fi

done
