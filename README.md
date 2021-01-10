# GPG-Automator
A Bash script for automating the backup, encryption and decryption of data using the GNU Privacy Guard command line tool.

## Prerequisites
This script requires an install of the GPG command line tool and a generated GPG key. Assign the required value of each global variable to suit your needs (see comments in code).

## Usage
![usage](https://github.com/SpuriousKelpie/GPG-Automator/blob/main/usage.png)

The backup option (-b) deletes the existing backup, and then copies the data to the backup location. The decrypt option (-d) decrypts the GPG encrypted archive file, and then extracts the data from the archive using Gunzip. The encrypt option (-e) deletes the existing encrypted archive and unencrypted archive. It then archives the data using Gzip and encrypts it using GPG. The data copied to the backup location is then deleted after it has been archived and encrypted.

## Contribute
If you would like to contribute to the project, then please contact me.

## License
GPG-Automator is licensed under the GNU General Public License v3.0.
