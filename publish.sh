#!/usr/bin/env bash
echo  $1
git add .
git commit -a -m "$1"
git push -u origin my_blog
pelican content -o output -s pelicanconf.py
ghp-import output -r origin -b master
git push origin master
git checkout my_blog

