#!/bin/bash

# suppression des espace dans des fichiers

ls | while read i; do j=$(echo "$i" | tr -d [:space:]); mv "$i" "$j";done

# chgt de nom de fichiers

ls | while read i; do j=$(echo "$i" | cut -d . -f 1); mv "$i" "$j""-1024x768.jpg";done
