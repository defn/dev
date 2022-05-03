#!/usr/bin/env python

docker_build('defn/dev:base', '.', dockerfile='Dockerfile.base',
    build_args={
        'IMAGE': 'ubuntu:22.04',
        'APT': '20220430'
    })

docker_build('defn/dev:tower', '.', dockerfile='Dockerfile.tower',
    build_args={
        'IMAGE': 'defn/dev:base',
        'APT': '20220429',
        'ASDF': '0.9.0',
        'BABASHKA': '0.8.1',
        'CILIUM': '0.11.4',
        'CIRRUS': '0.74.2',
        'CREDENTIAL_PASS': '0.6.4',
        'FLYCTL': '0.0.325',
        'GH': '2.9.0',
        'GOLANGCILINT': '1.45.2',
        'GORELEASER': '1.8.3',
        'HOF': '0.6.2-beta.1',
        'HUBBLE': '0.9.0',
        'JLESS': '0.8.0',
        'LINKERD': 'edge-22.4.1',
        'LOFT': '2.1.8',
        'POWERLINE': '1.21.0',
        'STEAMPIPE': '0.13.6',
        'STEP': '0.18.2',
        'VCLUSTER': '0.7.1',
        'YAEGI': '0.11.3'
    })

docker_build('defn/dev:ci', '.', dockerfile='Dockerfile.ci',
    build_args={
        'IMAGE': 'defn/dev:tower'
    })

services = {
        'dev': {'image': 'defn/dev:ci'}
    }

docker_compose(encode_yaml({'services': services}))
