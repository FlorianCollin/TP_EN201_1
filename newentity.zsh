#!/bin/zsh

# Vérifier si un argument a été fourni
if [ $# -ne 1 ]; then
    echo "Utilisation : $0 <nom_de_l_entite>"
    exit 1
fi

entity_name="$1"

touch "src/${entity_name}.vhd"

touch "testbench/${entity_name}_tb.vhd"

echo "Fichiers créés avec succès !"
