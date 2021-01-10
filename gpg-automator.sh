#!/bin/bash

#    Name: GPG-Automator
# Purpose: Automates the backup, encryption and decryption of data using GPG.
#  Author: SpuriousKelpie
# License: GPL-3.0

encrypted_backup_filepath="" # ABSOLUTE PATH TO GPG ENCRYPTED FILE
encrypted_backup_filename="" # NAME OF GPG ENCRYPTED FILE
archived_backup_filepath="" # ABSOLUTE PATH TO ARCHIVE FILE
archived_backup_filename="" # NAME OF ARCHIVE FILE
data_directory="" # ABSOLUTE PATH TO DATA DIRECTORY
backup_directory="" # ABSOLUTE PATH TO DATA BACKUP DIRECTORY
username="" # GPG USERNAME

usage(){
  printf "\nUsage: $0 [option]\n\n"
  printf "Options:"
  printf -- "\n  -b\tcopies the files to the backup location"
  printf -- "\n  -d\tdecrypts and then extracts the data from the archive"
  printf -- "\n  -e\tarchives the files using gzip and then encrypts the archive"
  printf -- "\n  -h\tdisplays the list of options\n\n"
}

backup(){
  if [ ! -d $backup_directory ]; then
    while true; do
      read -p "[!] No existing backup. Continue? [y/n]: " response
      case "$response" in
        "y" | "Y" | "yes" | "Yes") break ;;
        "n" | "N" | "no" | "No") exit 0 ;;
        *) echo "[!] Unknown response" ;;
      esac
    done
  fi
  if [ -d $backup_directory ]; then
      rm -r -I $backup_directory
  fi
  if [ -d $backup_directory ]; then
    echo "[!] The existing backup must be deleted"
    exit 1
  fi
  if [ ! -d $data_directory ]; then
    echo "[!] Path to data directory is invalid"
    exit 1
  fi
  echo "[*] Copying $data_directory to $backup_directory at $(date +%T)"
  cp -r $data_directory $backup_directory
  echo "[*] Finished at $(date +%T)"
}

encrypt(){
  rm -i $encrypted_backup_filepath
  if [ -f $encrypted_backup_filepath ]; then
    echo "[!] $encrypted_backup_filename must be deleted"
    exit 1
  fi
  rm -i $archived_backup_filepath
  if [ -f $archived_backup_filepath ]; then
    echo "[!] $archived_backup_filename must be deleted"
    exit 1
  fi
  if [ ! -d $backup_directory ]; then
    echo "[!] No copy of data found"
    exit 1
  fi
  echo "[*] Archiving data into $archived_backup_filename at $(date +%T)"
  tar czfP $archived_backup_filepath $backup_directory
  echo "[*] Encrypting $archived_backup_filename at $(date +%T)"
  gpg -e -r $username $archived_backup_filepath
  echo "[*] Deleting $archived_backup_filename"
  rm $archived_backup_filepath
  echo "[*] Deleting copy of the data"
  rm -r $backup_directory
  echo "[*] Finished at $(date +%T)"
}

decrypt(){
  if [ ! -f $encrypted_backup_filepath ]; then
    echo "[!] Path to $encrypted_backup_filename is invalid"
    exit 1
  fi
  echo "[*] Decrypting $encrypted_backup_filename at $(date +%T)"
  gpg -d -o $archived_backup_filepath $encrypted_backup_filepath
  echo "[*] Extracting files from $archived_backup_filename at $(date +%T)"
  tar xzfP $archived_backup_filepath
  echo "[*] Finished at $(date +%T)"
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

while getopts ":bdeh" option; do
  case $option in
    b) backup
    exit 0 ;;
    d) decrypt
    exit 0 ;;
    e) encrypt
    exit 0 ;;
    h|\?) usage
    exit 1 ;;
  esac
done
