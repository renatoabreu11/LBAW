# How to Run

What is [**Vagrant**](https://www.vagrantup.com/)?

Vagrant makes virtual machines disposable items. It helps you create a new VM from the ground up, and allows you to destroy it at will.

And [**Puppet**](https://puppet.com/)?

Puppet is a command line tool to install software on virtual machines.

With this in mind, we used [**PuPHPet**](https://puphpet.com/) to work with both softwares in order to set up a [virtual machine](LBAW%20Development%20Environment.tar.gz).
This machine comes installed with the software required in the LBAW course (PostgreSQL 9.4, Apache, PHP 7.1) and with a few extras that come in handy, such as [Composer](https://getcomposer.org/) and some [NPM packages](https://www.npmjs.com/).
Composer is a dependency manager for PHP and NPM is the package manager for JavaScript.

[Interesting read to know more about Puppet and Vagrant](https://jtreminio.com/2013/06/make_vagrant_up_yours/)

After downloading the [virtual machine](LBAW%20Development%20Environment.tar.gz), it's necessary to configure the '/puphpet/config.yaml' file, which contains all the configurations of our environment.
To configure the machine, simply change the config.yaml lines where there is a commentary explaining the use of that variable and a possible assignment.

Now, it's possible to deploy the vagrant machine. Just go to the directory where the vagrantfile is located and run "vagrant up"  (this will take a while…).
If no error has occurred, you can access the virtual machine with the command "vagrant ssh".

In this new machine, an Apache server is now running and a PostgreSQL database was created, accordingly to your configuration, which means that it has a similar environment to the one in "gnomo.fe.up.pt" and it's locally available to you.
We're almost there, bear with me a little longer.  Now, we need to redirect the access to "hostname.dev" - the domain defined in the config.yaml file - to the ip defined in the same file. To do that, we can add the following line “192.168.56.101 hostname.dev www&#8228;hostname.dev” to the file "/etc/hosts".
With this, the system will not do a DNS lookup for "hostname", but will automatically redirect to the defined IP address.
Now you can go to www&#8228;hostname.dev and navigate through our website.

## Required Software

### Ubuntu
* Vagrant
* VirtualBox

### Windows 
* VirtualBox 5.1.20
* Vagrant 1.9.2 (I advise the use of this version because i had some problems with the latest one)
* PuTTY and PuTTYGen
