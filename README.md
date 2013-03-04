less.app
========

A LESS - CSS converter app for Linux

Dependency
----------
inotify-tools  
For Fedora users  
```sh
$ sudo yum install inotify-tools   
```
For Debian users  
```sh
$ sudo apt-get install inotify-tools   
```

Installation
---------
Just run less.app with the syntax  
```sh
$ ./less.app sourceFolder destinationFolder  
```

create a dir like /usr/share/lessapp and put the file inside it. create a symbolic link to your bin folder  
```sh
$ ln -s /usr/share/lessapp/less.app /usr/bin/lessapp  
$ lessap mylessfolder mycssfolder  
```
If you get any issue, make sure the 'less.app' file is executable  
```sh
$ sudo chmod 755 /usr/share/lessapp/less.app  
```

Author
------
[Iso](http://code.krml.fr/less.app/ "BitBucket")
