#!/bin/bash
OPT_GIT=/opt/git/
repo=$1
if [ -z "$repo" ]; then
	echo "new-git [repo] (directory)"
        exit 1
fi
if [ $UID -ne 0 ]; then
        echo "must be run as root"
        exit 1
fi
use_dir=public/
if [ ! -z "$2" ]; then
	use_dir=$2/
fi
OPT_GIT=${OPT_GIT}$use_dir/
mkdir -p $OPT_GIT
repo=$OPT_GIT/$(echo $repo | sed "s/\.git$//g").git
mkdir -p $repo
git init --bare $repo
echo "$1" > $repo/description
chown git:git -R $repo
