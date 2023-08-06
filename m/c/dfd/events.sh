#!/usr/bin/env bash

set -exfu

for a in us-{west,east}-{1,2}; do
	export AWS_REGION=${a}
	~/bin/e aws ec2 describe-availability-zones
done
