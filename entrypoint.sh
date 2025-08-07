#!/bin/bash

# Start SSH
/usr/sbin/sshd

# Switch to matthew and run setup
sudo -u matthew bash -c "/home/matthew/startup.sh"

# Keep container running
tail -f /dev/null

