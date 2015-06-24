#/bin/bash
cd $(dirname $0)

NAME=$(cat info.json | grep name | awk '{gsub(/[",]/, "", $2); print $2}')
VERSION=$(cat info.json | grep version | awk '{gsub(/[",]/, "", $2); print $2}')

rm -rf build/
mkdir build
zip -r build/$NAME\_$VERSION.zip . -x "build/" ".git/" ".git*" "*.DS_Store"
