#!/bin/bash

usage() {
    echo "deploy.sh <executable> [output]"
}

output=.

if [[ $# < 1 ]]
then
    usage
    exit -1
fi

if [[ ! -e $1 ]]
then
    usage
    echo $1 not exists
    exit -1
fi

if [[ $# == 2 ]]
then
    output=$2
fi

if [[ ! -e $output ]]
then
    mkdir -p $output
fi

deplist=$(ldd $1 | awk '{if (match($3,"/")){ print $3}}')
# -L 表示拷贝文件（如果是软链，会拷贝到最终的文件）。  
# -n 表示不覆盖已有文件。  
cp -L -n -v $deplist $output
