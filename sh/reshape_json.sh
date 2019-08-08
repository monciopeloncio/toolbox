#!/bin/bash

# Iterate by multiple json line files, 
# Reshape the jsons using jq. More info: https://stedolan.github.io/jq/
# Concatenate the output in a file

for filename in path/*; do
    [ -e "$filename" ] || continue
    cat $filename | jq -c '{"key1": .key1, "key2": .key2}' >> 20190807.txt
done