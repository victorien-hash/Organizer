#!/bin/bash

# Prompt the user to enter the path of the folder to organize
read -p "Please enter the path of the folder to organize: " dossier_cible

# Verify that the entered folder exists
if [ ! -d "$dossier_cible" ]; then
  echo "Error: The folder '$dossier_cible' could not be found."
  exit 1
fi

# Prompt the user to enter the path of the 'extension.txt' file
read -p "Please enter the path of the 'extension.txt' file: " fichier_de_tri

# Verify that the 'extension.txt' file exists
if [ ! -f "$fichier_de_tri" ]; then
  echo "Error: The file 'extension.txt' could not be found."
  exit 1
fi

echo "The folder to organize is: $dossier_cible"
echo "The sorting file is: $fichier_de_tri"

# Array to store the files
declare -a tableau_de_fichiers

# Retrieve and store all files from the target folder in the array
for file in "$dossier_cible/"*; do
  if [ -f "$file" ]; then
    tableau_de_fichiers+=("$file")
  fi
done

# Display the files found
echo "The files found in the folder '$dossier_cible' are:"
for item in "${tableau_de_fichiers[@]}"; do
  nom_du_fichier=$(basename "$item")
  extension="${nom_du_fichier##*.}"
  echo "File name: $nom_du_fichier | Extension: $extension"
done

# Retrieve the username
utilisateur="$USER"

# Path of the new folder
nouveauDossier="$dossier_cible/Files_$utilisateur"

# Create the user's folder if it does not already exist
if [ ! -d "$nouveauDossier" ]; then
  mkdir "$nouveauDossier"
  echo "The folder '$nouveauDossier' has been created."
fi

# Use 'rsync' to copy files while excluding the destination folder itself
# This prevents an infinite copy loop of the user folder into itself
rsync -av --exclude="Files_$utilisateur" "$dossier_cible/" "$nouveauDossier/"

echo "The contents of the folder '$dossier_cible' have been copied to '$nouveauDossier'."

# Declare an array to store the files in the new user folder
declare -a tableau_de_fichiers2

# Populate the new array with file information
for file in "$nouveauDossier/"*; do
  if [ -f "$file" ]; then
    tableau_de_fichiers2+=("$file")
  fi
done

# Read the 'extension.txt' file and organize the files
while IFS=":" read -r category extensions; do
  category=$(echo "$category" | xargs)
  extensions=$(echo "$extensions" | xargs)
  
  dossier_categorie="$nouveauDossier/$category"
  mkdir -p "$dossier_categorie"
  
  # Convert extensions into an array
  IFS=", " read -r -a exts <<< "$extensions"
  
  # Move files into the corresponding folders
  for item in "${tableau_de_fichiers2[@]}"; do
    nom_du_fichier=$(basename "$item")
    extension="${nom_du_fichier##*.}"
    
    # Check if the extension matches the current category
    for ext in "${exts[@]}"; do
      if [ "$extension" == "$ext" ]; then
        mv "$item" "$dossier_categorie"
        echo "The file '$nom_du_fichier' has been moved to the folder '$category'."
        break
      fi
    done
  done
done < "$fichier_de_tri"

# Create the info.txt file
info="$nouveauDossier/info.txt"

# Retrieve the current date
date=$(date "+%Y-%m-%d")

# Loop through all dynamically created folders in the user folder
for dossier in "$nouveauDossier"/*; do
  if [ -d "$dossier" ]; then
    # Retrieve the folder name
    nom_dossier=$(basename "$dossier")
    
    # Count the number of files in this folder
    nbr_fichiers=$(ls "$dossier" 2>/dev/null | wc -l || echo 0)
    
    # Add the result to the info.txt file
    echo "Number of files in $nom_dossier: $nbr_fichiers" >> "$info"
    
    # Update the total file count
    total_fichiers=$((total_fichiers + nbr_fichiers))
  fi
done

# Add additional information to the info.txt file
echo "" >> "$info"
echo "Total number of files: $total_fichiers" >> "$info"
echo "Date: $date" >> "$info"
echo "User: $utilisateur" >> "$info"

echo "The 'info.txt' file has been successfully generated."
