#!/bin/bash
#
# Created By: ssarver
# Created Date: Wed Oct 19 11:13:21 CDT 2016

clear

echo "============== Starting SSL Script ==========================="


echo "Google has a root certificate in the trust chain called 'Equifax Secure Certificate Authority'"
echo "The Equifax certificate is trusted by the operating system because the default ca-certificates page includes that certificate. "
echo "This means that simple https curl request should complete succefully...."
curl -vL https://google.com
echo "  "

#Show a successful case
echo " "
echo "________________________________________________________________________ "
echo "Case 1: Successful ssl handshake "
echo " "
echo "The following ssl connection negotiation completes successfully using the operating systems trusted certificates and negotiating for protocol and cipher."
openssl s_client -CApath /etc/ssl/certs/ -host google.com -port 443 <<HERE1

HERE1


#SHow a rejected case using ssl3
echo " "
echo "________________________________________________________________________ "
echo "Case 2: Wrong SSL version "
echo " "
echo "The following ssl connection negotiation fails since we specify only ssl version 3 which googles servers do not support."
echo "The failure is evidenced by the message: 'error:1408F10B:SSL routines:SSL3_GET_RECORD:wrong version number'"
echo "You will also see that no certificate is sent since the protocol can not be agreed upon."
echo " "
openssl s_client -CApath /etc/ssl/certs/ -ssl3 -host google.com -port 443 <<HERE2

HERE2
# -ssl2         - just use SSLv2
# -ssl3         - just use SSLv3
# -tls1_2       - just use TLSv1.2
# -tls1_1       - just use TLSv1.1
# -tls1         - just use TLSv1
# -dtls1        - just use DTLSv1

echo "============== DONE ==========================="
