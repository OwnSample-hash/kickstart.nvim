#!/bin/bash

set -ex

git branch -m main archive-$(date)
git branch -b main
git am patches/*.patch

