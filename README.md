Less css - Command line helper
========

A folder watchert that uses `lessc` to convert less to css app for Linux

Dependency
----------
**lessc**
Checkout [lesscss website](http://lesscss.org/usage/#command-line-usage) for more information about `lessc` command

**inotify-tools**  
For Fedora users  
```sh
$ sudo yum install inotify-tools   
```
For Debian users  
```sh
$ sudo apt-get install inotify-tools   
```

Usage
---------
To watch `source_folder` Just run less.app with the syntax  
```sh
$ ./less.app source_folder destination_folder  
```

create a dir like /usr/share/lessapp and put the file inside it. create a symbolic link to your bin folder  
```sh
$ ln -s /usr/share/lessapp/less.app /usr/bin/lessapp  
$ lessap styles/less styles/css  
```
If you get any issue, make sure the 'less.app' file is executable  
```sh
$ sudo chmod 755 /usr/share/lessapp/less.app  
```
