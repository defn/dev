#!/usr/bin/env bash

# env vars: TS_CLIENT_ID, TS_CLIENT_SECRET, NODE_NAME

export TOKEN=$(curl -s -d "client_id=${TS_CLIENT_ID}" -d "client_secret=${TS_CLIENT_SECRET}" "https://api.tailscale.com/api/v2/oauth/token" | jq -r '.access_token')
export AUTH_KEY=$(curl -s -X POST -u "${TOKEN}:" "https://api.tailscale.com/api/v2/tailnet/-/keys" -H 'Content-Type: application/json' -d '{"capabilities":{"devices":{"create":{"reusable":false,"ephemeral":true,"preauthorized":false,"tags":["tag:aws"]}}},"expirySeconds":60,"description":"Type your description"}' | jq -r '.key')

if [ ! -z "${NODE_NAME}" ]; then
	IDS=$(curl -s -u "${TOKEN}:" https://api.tailscale.com/api/v2/tailnet/-/devices | jq -r --arg node "${NODE_NAME}" '.devices[] | select(.hostname == $node) | .nodeId')
	for ID in ${IDS}; do
		echo "deleting node $ID"
		curl -X DELETE -u "${TOKEN}:" "https://api.tailscale.com/api/v2/device/${ID}"
		echo
	done
fi

echo tailscale up --hostname=$NODE_NAME --auth-key=$AUTH_KEY
