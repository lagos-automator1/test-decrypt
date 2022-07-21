#!/bin/bash

set -e

echo "Input File Name To Be Decrypted:"
read -r file

if [ "x${file}" = "x" ]; then
   echo "Please execute this script from the repo root path and input secret file name without extension"
   exit 1
else
   fileNameWithPath=$(find ./src/main/secrets/values -name "${file}.aes256")
   filePath=$(dirname "$fileNameWithPath")

   if [ -f "${fileNameWithPath}" ]; then

      find "${filePath}" -name "${file}.aes256" | while read -r each; do
        echo "decrypting ${each} using sha256 aes256 starts"
        fileName=$(echo "${each}" | awk -F ".sha256.aes256" '{print $1}')
        openssl enc -md sha256 -aes-256-cbc -pbkdf2 -d -base64 -k EECpGrE2FfnF7TyFxfv3adNVATlSiuGLb5A -in "${each}" -out "${fileName}.txt"
        echo "decrypting ${each} using sha256 aes256 done"
      done

      unset passphrase
   else
      echo "Input File Name - ${file} NOT FOUND!!"
      exit 1
   fi
fi

unset file

# EOF
