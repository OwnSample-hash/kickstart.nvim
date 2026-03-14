#!/bin/bash

set -e

mkdir -p patches

CURRENT_BR=$(git branch --show-current)

git checkout -b develop origin/master
git am patches/*.patch
PATCHES=$(find patches -type f)
git update-index --assume-unchanged $PATCHES

echo Staring dev shell commit every change you wish to add to the patch set
case $SHELL in
  *bash)
    set +e
    bash --init-file <(echo "source ~/.bashrc;export PS1=\"(develop) \$PS1\"")
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
git update-index --no-assume-unchanged $PATCHES

