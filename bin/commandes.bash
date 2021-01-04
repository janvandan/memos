#!/bin/bash

# suppression des espace dans des fichiers

ls | while read i; do j=$(echo "$i" | tr -d [:space:]); mv "$i" "$j";done

# chgt de nom de fichiers

ls | while read i; do j=$(echo "$i" | cut -d . -f 1); mv "$i" "$j""-1024x768.jpg";done

# chgt le début du nom

ls | while read i; do j=$(echo "$i" | cut -c 6-); mv "$i" "David-$j";done

# recherche des fichiers crééés à une date spécifique

find . -newerBt '2020-12-28' -print
find . -newerBt '2020-12-28' -ls
