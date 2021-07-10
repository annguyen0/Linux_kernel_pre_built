#!/bin/bash

kernel_list=$(curl -s https://www.kernel.org/ | grep "<td><strong>" | awk -F '>' '{print$3}' | awk -F '<' '{print$1}')

echo "$kernel_list" > /workdir/kernel_list.txt

kernel_list="/workdir/kernel_list.txt"

while IFS= read -r kernel_ver
do 
    github_ver=$(curl -s 'https://api.github.com/repos/anphucnguyen/Linux_kernel_pre_built/releases' | grep $kernel_ver)
    if [ "X$github_ver" != "X" ] || [ $kernel_ver == *"next"* ]; then 
        echo "::set-output name=status::fail"
    else 
        echo "::set-output name=status::success"
        echo "::set-env name=LINUX_VER::$kernel_ver"
        break 2
    fi
done < "$kernel_list"

