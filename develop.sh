#!/bin/bash

set -e

mkdir -p patches

CURRENT_BR=$(git branch --show-current)

echo "patches" | tee -a .gitignore
git checkout -b develop origin/master
git am patches/*.patch

echo Staring dev shell commit every change you wish to keep
case $SHELL in
  *bash)
    set +e
    bash --init-file <(echo "export PS1=\"(develop) \$PS1\"")
    set -e
  ;;

  *zsh)
    set +e
    ZDOTDIR=$(realpath .) $SHELL
    set -e
  ;;

  *)
    echo "Shell ($SHELL) is not supported!"
  ;;
esac

rm patches/*.patch
git format-patch origin/master..develop -o patches
git checkout $CURRENT_BR
git branch -D develop
sed -i "s/patches//" .gitignore
