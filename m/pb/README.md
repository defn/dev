# Ansible Playbooks

This is the workarea for Ansible playbooks, inventories, and mise tasks.

## Playbooks

Machine executable playbooks are yaml files.  They are imported into people useable playbooks, which are managed by cuelang.

## Inventory

Inventories are also managed by cuelang.  Dynamic inventories for cloud jostswre merged with static configs, then augmented with global, group, and host variables using cuelang.

## mise tasks

The Ansible mise tasks can be run anywhere.  They use a central ansible.cfg in $HOME, which configures paths to m/pb.  They also have a declarative namespace that looks up playbooks and inventories.

- m play PLAYBOOK LIMIT - runs a playbook on hosts
- m local PLAYBOOK - runs a playbook locally
- m remote COMMAND LIMIT - runs a command on hosts

If LIMIT is omittted, fzf offers an inventory menu.

If PLAYBOOK is a file, that file,is use as the playbook.  Otherwise, the playbook is mapped to m/pb/PLAYBOOK.yaml or a cuelang generated playbook.

## Access

When accessing AWS, such as for secrets, the defn-org account is selected using mise.

## TODO

- move mise tasks to m/pb
- use ansible from m/pb when twsks can be run from anywhere
- decide id Ansiblr is a global tool
- authenticate with AWS as needed but not during a play
- figure out how cuelang generates people play books
- figure out how m play finds cuelang playbooks
- example of a playbook in another workarea
