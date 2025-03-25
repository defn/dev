SHELL := /bin/bash

fmt: # Format packer configs
	packer fmt -write=true .

# cleaning
clean:
	$(MAKE) clean-ami clean-snapshot

clean-ami:
	$(MAKE) clean-ami-prefix prefix="base-*"
	$(MAKE) clean-ami-prefix prefix="coder-*"

clean-ami-prefix:
	aws ec2 describe-images --owners self --filters "Name=name,Values=$(prefix)" "Name=state,Values=available" --query 'Images | sort_by(@, &CreationDate) | reverse(@)' | jq -r '.[].ImageId' | tail -n +2 | runmany 'set -x; aws ec2 deregister-image --image-id $$1'

clean-snapshot:
	comm -23 <(aws ec2 describe-snapshots --owner-ids self --query 'Snapshots[*].SnapshotId' --filters "Name=description,Values=Created by CreateImage*" | jq -r '.[]' | sort) <(aws ec2 describe-images --owners self --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text | sort) | runmany 'set -x; aws ec2 delete-snapshot --snapshot-id $$1'

# ami
coder:
	mise trust
	mise install
	mise exec -- packer init $@.pkr.hcl
	env AWS_PROFILE=defn-org mise exec -- packer build -color=true -timestamp-ui=true $@.pkr.hcl

sync:
	regsync once -c regsync.yaml
