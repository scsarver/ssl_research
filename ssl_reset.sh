#!/bin/bash
#
# Created By: ssarver
# Created Date: Wed Oct 19 15:41:22 CDT 2016

clear

echo "============== Starting SSL RESET Script ==========================="
echo " "
echo "Resetting the disabled certificates. "

for cert in $(cat remove_certificates.txt); do
  echo $cert
  sed -i "s~!$cert~$cert~g" /etc/ca-certificates.conf
done

echo " "
echo "Run the update based on the new configuration file changes resettign the disabled certificates."
update-ca-certificates

echo " "
echo "============== DONE ==========================="
