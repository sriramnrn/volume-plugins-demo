#!/bin/bash

# You can find your token but logging in to VolumeHub
# and navigating to https://volumehub.clusterhq.com/v1/token
[ -z "$TOKEN" ] && echo "Need to set TOKEN for VolumeHub" && exit 1;

# Control service setup
vagrant ssh node1 -c "sudo \
  TARGET=control-service \
  TOKEN=${TOKEN} \
  sh -c 'curl -ssL https://get-volumehub.clusterhq.com/ |sh'"

# Need to run this once, lets run it on node2
vagrant ssh node2 -c "sudo \
  TARGET=agent-node \
  RUN_FLOCKER_AGENT_HERE=1 \
  TOKEN=${TOKEN} \
  sh -c 'curl -ssL https://get-volumehub.clusterhq.com/ |sh'"

# Control node is also an agent node.
vagrant ssh node1 -c "sudo \
  TARGET=agent-node \
  TOKEN=${TOKEN} \
  sh -c 'curl -ssL https://get-volumehub.clusterhq.com/ |sh'"

echo "Done! Go to https://volumehub.clusterhq.com/"