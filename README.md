
# Description:

 This script is the skeleton installation of taiga production install - taigaio.github.io/taiga-doc/dist/setup-production.html
 It doesn't configure events as it is marked as optional
 start.sh is the main script creating a new user 'taiga' and running prerequisites install scripts under it.

# Was built with:

 Ubuntu 16.04.05
 Taiga-backend
   branch: stable
   commit: 1a850f51792a13c4795aa25a04d739d2b940b22a
 Taiga-frontend
   branch: stable
   commit: ca2c7bd34af4117af9f5d50f88b401adc24a0844

# Scripts Description:

 taiga-shell-install/
 ├── bin
 │   ├── 4-backend.sh : taiga-backend
 │   ├── 5-frontend.sh : taiga-frontend
 │   ├── 7.1-startExpose.sh : circus 
 │   └── 7.2-nginx.sh : nginx
 ├── etc
 │   └── conf.sh : changeMe variables
 ├── README.md : This Readme
 └── start.sh : Install script

# Notes:
 * User taiga is being granted with 'sudo without password' at the beggining of the script and revoked at the end, in case of failure /etc/sudoers rule should be manually removed
 * Failed to install on Ubuntu 18.04.*
