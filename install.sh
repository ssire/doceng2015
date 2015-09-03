#! /bin/sh

#
# Copier dans le répertoire du cours et ajuster le nom du répertoire cible
#

DEST_DIR_NAME="../pub"
DEST_DIR="$DEST_DIR_NAME/."

mkdir -p $DEST_DIR
mv *.xhtml $DEST_DIR
