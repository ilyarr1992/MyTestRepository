#!/bin/bash

VERSION="bvmvhjkmvhjkhv"
EXTENSION="fngj"

### Functions for code ###

#######################################
# Check if current version of PHP is equal inputed

check_version () {
    [[ $(rpm -qa | grep php-cli | grep $VERSION) ]];
}

#######################################
# If inputed extension is not installed
# then install this extension and then show message about it

extension_no () {
    echo "Extension installing..."
    sudo yum install php-pear -y > /dev/null
    sudo pecl install "$EXTENSION" -y > /dev/null
    echo "$EXTENSION was installed!"
}

#######################################
# If inputed version is equal current
# then show message about it

right_php () {
    echo "PHP $VERSION is already installed!"
}

#######################################
# If inputed version is not equal current
# then uninstall/install new version

wrong_php () {
    echo "New version of PHP installing..."
    yum -y remove php* > /dev/null 2>>errors_log.txt
    dnf module reset php -y > /dev/null 2>>errors_log.txt
    sudo yum module enable php:remi-$VERSION -y > /dev/null 2>>errors_log.txt	
    sudo dnf module install php:remi-$VERSION -y > /dev/null 2>>errors_log.txt
    sudo dnf install php -y > /dev/null 2>>errors_log.txt
    sudo systemctl start php-fpm 
    sudo systemctl enable php-fpm 
    echo "PHP $VERSION was installed!"
}

#######################################
# Check if inputed extension is already installed
# if YES then show message about it
# if NO then do "extension_no" function

check_extension () {
    if [[ $(php -m | grep -q $EXTENSION) -eq $EXTENSION ]]; then
        echo "the $EXTENSION extension is already installed"
    else
	extension_no
    fi

}

###### Code ######

#echo "For correct work please input the version of PHP first, then all needed pecls"
#read 
echo "$@"   
for opt in "$@"; do
    case ${opt} in
        -v)
            VERSION=$2
	    if check_version
            then
                right_php
	    else
	        wrong_php
            fi ; shift ; shift ;;
         --pecl)
            EXTENSION=$2
	    check_extension ; shift; shift ;;
    esac
done

if [[ $VERSION == "bvmvhjkmvhjkhv" ]]; then
    echo "version error"
    exit 1
fi

if [[ $EXTENSION == "fngj" ]]; then
    echo "extension error"
    exit 1
fi
