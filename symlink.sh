#!/bin/sh

basepath=$(cd $(dirname $0);pwd)

# symlink dotfiles into ~
files=.*
for file in $files
do
    if [ $file != "." -a $file != ".." -a $file != ".git" -a $file != ".gitignore" ] ; then
        ln -sf $basepath/$file ~
    fi
done

ln -sf $basepath/vim ~/.vim
ln -sf $basepath/gitignore ~/.gitignore
