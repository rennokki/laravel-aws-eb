#!/bin/bash

# echo '{
#         "logs": {
#             "logs_collected": {
#                 "files": {
#                     "collect_list": [
#                         {
#                             "file_path": "/var/app/current/storage/logs/*.log",
#                             "log_group_name": "/aws/elasticbeanstalk/<you-environment-name>/var/app/current/storage/logs/",
#                             "log_stream_name": "{instance_id}"
#                         }
#                     ]
#                 }
#             }
#         }
#     }' > "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/mycustomlogs.json"
# /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config
# /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop
# /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
