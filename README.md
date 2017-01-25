# ssl_research

## SSL Research  

The purpose of this project is to demonstrate how SSL certificates work and as a repository of markdown notes for related ssl/tls/ssh research.  

#### What is SSL?  

SSL or 'Secure Sockets Layer' is a computer networking protocol that manages client
server authentication between network endpoints and allows encrypted communication
between those endpoints. This authentication is done using public-key and symmetric-key
encryption to secure the connection.

How does it work with out hurting my brain?

To start an encrypted connection the client computer will initiate a 'handshake'
where it requests the digital certificate of the server it wants to make its connection to.

1.) The client starts the communication with a hello request that includes the SSL options it understands  
2.) The server responds with a hello request that includes the SSL options that both the client and the server understand.  
3.) The server also sends its certificate for the client to verify its identity with.  
4.) The server then sends a notification that the hello step is complete.  
5.) The client verifies the certificate against its trusted certificates to determine if the connection can proceed.  
6.) If the certificate can be trusted the client sends a encrypted session key using the servers provided certificate.  
7.) The client then builds the set of encryption options that it expects to use for thee session and sends them to the server.  
8.) The client asks for verification of the encryption options.  
9.) The server responds to the clients set of encryption options verifying that the connection can be made.  
10.) The client then begins sending data over the newly created connection.  

#### How do I see a servers certificate?  
- OpenSSL provides a tool to allow you to inspect the certificates used to make the
SSL connection. The following openssl command will:  
    - Connect to the specified domain/server  
    - Display the certificates chain of trust  
    - Display the certificate  
    - Display the bytes read to negotiate the encryption terms the connection will be made  
    - Display the connection terms/properties  

    Example:  
    `openssl s_client -host google.com -port 443`  

#### How do I see the certificates my server trusts(Ubuntu 12.04)?  
The following apt-cache commands will show varying amounts of information on the ca-certificates package.  
`apt-cache search ca-certificates`  
`apt-cache show ca-certificates`  
`apt-cache showpkg ca-certificates`  
`apt-cache policy ca-certificates`  

#### Common problems and how to understand what needs to be fixed:  
- The client and server can not agree on the SSL options to use.  
  - protocol version  
  - cipher version  
- The client does not trust a servers certificate  
  - The root CA is not trusted  
  - The certificate presented to the client is self-signed  
  - A certificate in the chain of trust has expired.  

#### Demo environment requirements:
Git  
Vagrant  
VirtualBox  

#### How do I run the Demo:  
- Assuming you meet the Demo environment requirements noted above checkout this project using git.  
- run the command:  
      `vagrant up`  
- Once your vagrant machine has been built and is running check the status by issuing the following command:  
      `vagrant status`  
    I would expect to see the following:  
      `Current machine states:`  
      `ssl1                      running (virtualbox)`  
- Use the ssh utility of vagrant to get a terminal into your virtual machine:  
      `vagrant ssh`
- Once you are on your virtual machines shell you can verify that the shell scripts have been placed in your home directory by issuing the following command:      
      `ls -l`  
    I would expect to see the following:
      `total 15`  
      `-rwxr----- 1 vagrant vagrant 1813 Oct 19 20:50 break_ssl.sh`  
      `-rwxr----- 1 vagrant vagrant  533 Oct 19 20:50 ssl_reset.sh`  
      `-rwxr----- 1 vagrant vagrant 1789 Oct 19 20:50 ssl.sh`  
- Run the first bash script to show the default state of the ssl connections by issuing the following command:  
      `./ssl.sh`  
    Here will show a series of comments and commands issued demonstrating verbosely https requests being made.   
- Run the second bash script to break the trust chain of your virtual machines operating systems certificates.
      `./break_ssl.sh`  
    Here will show a series of comments and commands issued removing Equifax and GeoTrust certificates form the system and demonstrating verbosely https requests being made that fail.  
- Run the third bash script to fix your virtual machines operating system certificates.     
      `./reset_ssl.sh`  
    Here will show a series of comments and commands issued that repair the changes made by the break_ssl.sh script.  


#### Ubuntu 12.04 and SSL  
Openssl version: OpenSSL 1.0.1 14 Mar 2012  
    `openssl version`  
Certificate directory: /etc/ssl/certs  
Apt package that sets the OS level trusted certificates: ca-certificates  

References:
- https://help.ubuntu.com/12.04/serverguide/certificates-and-security.html
- http://searchsecurity.techtarget.com/definition/Secure-Sockets-Layer-SSL
- http://security.stackexchange.com/questions/59566/ssl-certificate-chain-verification
- http://security.stackexchange.com/questions/56389/ssl-certificate-framework-101-how-does-the-browser-actually-verify-the-validity
- https://support.f5.com/kb/en-us/solutions/public/15000/200/sol15292.html
- https://www.digicert.com/digicert-root-certificates.htm
