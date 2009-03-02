#!/bin/bash

# convert files (the contents) to UTF-8
# NOTE: not interactive and might lead to data-loss! BACKUP BEFORE

for file in `ls`; do
    iconv -f ISO-8859-9 -t UTF-8 -o ".utf8_$file" "$file"
    mv ".utf8_$file" "$file"
done
