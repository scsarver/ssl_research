#!/bin/bash
#
# Created By: ssarver
# Created Date: Wed Oct 19 15:44:11 CDT 2016

clear

echo "============== Starting BREAK SSL Script ==========================="

echo " "
echo "________________________________________________________________________ "
echo "Case: removed root CA "
echo " "
echo "First lets make a backup of our ca-certificate file."
cp /etc/ca-certificates.conf /etc/ca-certificates.conf.bak
ls -la /etc | grep ca-certificates.conf.bak
echo " "
echo "Next we will disable the Equifax and GeoTrust certificates in our trusted ca configuration file."
cat /etc/ca-certificates.conf | grep "Equifax" >remove_certificates.txt
cat /etc/ca-certificates.conf | grep "GeoTrust" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "578d5c04.0" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "594f1775.0" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "74c26bd0.0" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "79ad8b43.0" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "e7b8d656.0" >>remove_certificates.txt
cat /etc/ca-certificates.conf | grep "ef2f636c.0" >>remove_certificates.txt

for cert in $(cat remove_certificates.txt); do
  echo $cert
  sed -i "s~$cert~!$cert~g" /etc/ca-certificates.conf
done

echo " "
echo " "
echo "Next we run the update based on the configuration file changes."
update-ca-certificates

echo " "
echo " "
echo "Now that we have disabled the trusted certs that goggles trust chain is built on the ssl connection will fail with an untrusted certificate. "
openssl s_client -CApath /etc/ssl/certs/ -host google.com -port 443 <<HERE1

HERE1

echo " "
echo " "
echo "This can also be seen by the rejection we get when trying to curl google. "
curl -vL https://google.com
echo " "

echo "============== DONE ==========================="
