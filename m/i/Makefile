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
%:
	mise trust
	mise install
	packer init $@.pkr.hcl
	packer build -color=true -timestamp-ui=true $@.pkr.hcl

home:
	docker build -t 169.254.32.1:5000/defn/dev:base . 
	docker push 169.254.32.1:5000/defn/dev:base

latest:
	docker build --no-cache -t 169.254.32.1:5000/defn/dev:latest -f Dockerfile.latest . 
	docker push 169.254.32.1:5000/defn/dev:latest

pull:
	docker pull district.tail3884f.ts.net/defn/dev
	docker tag district.tail3884f.ts.net/defn/dev 169.254.32.1:5000/defn/dev
	docker push 169.254.32.1:5000/defn/dev
