## Linux Installation

This repository has been tested and developed on Ubuntu 24.04 with the user `ubuntu` in home directory `/home/ubuntu`.

Install OS tools. These instructions assume `sudo` is installed and configured to allow `ubuntu` user to run commands as `root`.

```
sudo apt update
sudo apt install -y git
```

Clone the repo to your `/home/ubuntu` directory. The process below will overwrite files typically customized by the user.

```
cd $HOME
git clone https://github.com/defn/dev dev
mv dev/.git .
rm -rf dev
git reset --hard
```

Then install the tool dependencies:

```
./install.sh
```

After install, use new terminal sessions to load the `$HOME` configuration with `defn/dev` configuration and tooling.
