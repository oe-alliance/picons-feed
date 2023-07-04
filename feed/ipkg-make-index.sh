#!/bin/bash

set -e

touch Packages

for pkg in $(find . -name '*.ipk' | sort); do
    echo "Generating index for package $pkg" >&2
    file_size=$(ls -l --dereference $pkg | awk '{print $5}')
    md5sum=$(md5sum $pkg | awk '{print $1}')
    pkg_name=$(basename $pkg)
    description=$(echo "$pkg_name" | sed 's/^enigma2-plugin-picons-//' | sed 's/_.*$//')
    newversion=$(echo "$pkg" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    ar p "$pkg" control.tar.gz | tar -xzOf- './control' |
    awk -v newver="$newversion" -v pkgname="$pkg_name" -v filesize="$file_size" -v md5="$md5sum" -v description="$description" '{
    if ($0 ~ "^Version:") {
      printf "Version: %s\n", newver
    } else if ($0 ~ "^Description:") {
      printf "Filename: %s\nSize: %s\nMD5Sum: %s\nDescription:%s\n", pkgname, filesize, md5, description
    } else {
      print
    }
  }' >> Packages
    echo "" >> Packages
    echo "" >> Packages
done

gzip -c Packages > Packages.gz
