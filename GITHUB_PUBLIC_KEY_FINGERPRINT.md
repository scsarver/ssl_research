### Verify a public keys fingerprint to solve Github connectivity issues. ###
The case that brought me to write this short note involved a users sudden inability  
to connect to github when executing a capistrano build and receiving an error like  
the following:   

    `The deploy has failed with an error:  
    #<SSHKit::runner::ExecuteError: Exception while executing on host xxx.xxxxxx.xxx: exit>`  

Some of the clues for this case involved:  
- The user just upgraded the operating system software  
- The new OS had a version of OpenSSH that made DSA keys obsolete  
- The user had a DSA key and so had to generate a new key using RSA  

So after some searching and getting a hold of the build execution log I was able to  
see that the culprit of the failing build was happening due to  permissions:  

          DEBUG[a8784a27] Running /usr/bin/env git ls-remote -h git@github.com:xxxxxx/xxxxxx.git on xxx.xxxxxx.com  
          DEBUG[a8784a27] Command: ( GIT_ASKPASS=/bin/echo GIT_SSH=/tmp/xxxxxx/git-ssh.sh /usr/bin/env git ls-remote -h git@github.com:xxxxxx/xxxxxx.git )  
          DEBUG[a8784a27] 	Permission denied (publickey).  
          DEBUG[a8784a27] 	fatal: The remote end hung up unexpectedly  

This lead me to ask the question if there was possibly a problem when copying the  
new rsa key to github which brings me to the point of this note:  How do we verify  
that the public key we put in github matches the public side of our private key on  
our system?

So first we want to get the fingerprint of the key in github which will be under  
your account settings 'SSH and GPG keys' at this url: https://github.com/settings/keys  
and my look like the following:  

          13 xxxxxxxx id_rsa.pub
          Fingerprint: af:b7:c1:d4:ef:8a:b5:88:08:cd:08:5e:f7:89:ab:c2
          Added on Dec 18, 2015 — Last used within the last day

Now in order to find out the finger print of the key on our system we will want  
to verify or list the key to be sure the key is the one we expect:

          ssh-keygen -lf ~/.ssh/id_rsa.pub

This should produce output like the following:

          4096 SHA256:KK8NqIg6x2VTnTz6K2hXvZv4Y1cJpn5XEuWBKWVapgx youremail@yourdomain.com (RSA)  

If this is the corrrect key you want to get the MD5 fingerprint hash of the public key which  
you can compare to the MD5 fingerprint hash calculated by github by executing the following:

          ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub

This should produce output like the following:

          4096 MD5:af:b7:c1:d4:ef:8a:b5:88:08:cd:08:5e:f7:89:ab:c2 youremail@yourdomain.com (RSA)

Now by comparing side by side the MD5 hashes we will see they are the same. If the  
fingerprints are different you will get an authentication error when trying to connect to github.  
Common solutions to this are as follows:  
- Make sure you are copying the public side of your private/public key pair typically having a .pub file extension.  
- Make sure you are not copying any extra spaces or characters.
- Make sure you are not including an extra blank line when copying.

If you have verified the ssh key and it is not the problem here are some other  
related issues:
- Make sure your git config files email address for your user matches the github  
users email address and has your public key.

It is also helpful to verify that your key has been added to your ssh agent by executing the following:

          ssh-add -l





#### References: ####  
https://discussions.apple.com/thread/7685687?start=0&tstart=0  
https://forums.developer.apple.com/thread/48794  
http://stackoverflow.com/questions/9607295/how-do-i-find-my-rsa-key-fingerprint  
