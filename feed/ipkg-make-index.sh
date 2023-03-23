#!/bin/bash

set -e

touch Packages1

for pkg in $(find . -name '*.ipk' | sort); do
    echo "Generating index for package $pkg" >&2
    file_size=$(ls -l --dereference $pkg | awk '{print $5}')
    md5sum=$(md5sum $pkg | awk '{print $1}')
    pkg_name=$(basename $pkg)
    ar p $pkg control.tar.gz | tar -xzOf- './control' | sed -e "s/^Description:/Filename: $pkg_name\\
Size: $file_size\\
MD5Sum: $md5sum\\
Description:/" >> Packages1
    echo "" >> Packages1
done

gzip -c Packages1 > Packages1.gz