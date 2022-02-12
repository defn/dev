Setup ssh key in `home/.ssh/authorized_keys`

Run tilt `tilt up`

ssh to container `ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsfile=/dev/null ubuntu@localhost`
