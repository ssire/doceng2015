#! /bin/sh

#
# Copier dans le répertoire du cours et ajuster les noms des fichiers sources à transformer
#

J1="architecture install-and-configure practices"
ALL_FILES="program $J1 $J2 $J3"

for F in $ALL_FILES; do
    echo "./cours.sh $F"
done
