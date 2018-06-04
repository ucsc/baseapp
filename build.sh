#!/bin/bash
# production its_app_admin group
# dev and stage its_web_admin group

# expected permissions for Laravel applications
# 
# standard files 644 its_app_admin/its_web_admin group
# standard dirs 755 its_app_admin/its_web_admin group

# bootstrap/cache 755 apache9004 group
# bootstrap/cache/services.php 775 apache9004 group
# note this services file will get written only if there are changes

# storage 775 apache9004 group 
# storage/app 775 apache9004 group (must exist)
# storage/app/public 775 apache9004 group 
# storage/dtp 775 apache9004 group
# storage/framework 775 apache9004 group (must exist)
# storage/framework/sessions 775 apache9004 group (must exist)
# storage/framework/views 775 apache9004 group (must exist)
# storage/framework/cache 775 apache9004 group (must exist)
# storage/framework/sessions 775 apache9004 group (must exist)
# storage/logs 775 apache9004 group (must exist)

# files and dirs under storage/framework/cache will auto create with
# owner apache9004 and group apache9004 when the server runs

# we should also probably run php artisan cache:clear

createStorageDirs() {
    if [ ! -d storage ]; then
        #provide for the case where no storage folder exists yet 
        mkdir -p storage/app/public
        mkdir -p storage/framework/cache
        mkdir -p storage/framework/sessions
        mkdir -p storage/framework/views
        mkdir -p storage/logs
        if [ ! -f storage/logs/laravel.log ]; then
            touch storage/logs/laravel.log
        fi
    fi
    if [ ! -d import ]; then
        mkdir import
    fi
}

set_htaccess () {

    #it is really document root
    #for now assume the script is run from this dir
    #since all the artisan commands need to be 
    echo "setting htaccess"
    foo=`pwd`
    this_dir=`basename $foo`

    TMPFILE=.htaccess.lamp.$$
    if [ "$_TIER" == "local" ]; then
        echo "local - using default rule"
    else
        echo "hosted - using hosted rule"
        # sed here
        MYVAR='  RewriteRule \^(.\*)\$ '"${this_dir}"'\/index.php'
        #MYVAR="$this_dir"
        cat .htaccess | sed -e 's/  RewriteRule \.\* index.php \[L\]/'"$MYVAR"'/' > $TMPFILE
        mv $TMPFILE .htaccess
    fi
}


createEnv () {
    if [ ! -f .env ]; then
        echo "adding .env"
        cp .env.example .env
    fi
    echo "setting env to $_APP_ENV"
    # could use a single file but would require more sed
}

set_env () {
    if [ "$_TIER" == "local" ]; then
       echo "local, using default APP_ENV"
    else
        # sed here
        TMPFILE=.env.lamp.$$
        echo "setting env to $_APP_ENV"
        cat .env.example | sed -e "s/APP_ENV=local/APP_ENV=${_APP_ENV}/" > $TMPFILE
        mv $TMPFILE .env
    fi
}

set_sqlite () {
    echo "updating .env file for sqlite"
    if [ -f .env ]; then
        TMPFILE=.env.tmp.$$
        cat .env | sed -e "s/mysql/sqlite/" > $TMPFILE
        mv $TMPFILE .env
    fi
}
set_ssl () {
    echo "updating .env file for ssl"
    if [ -f .env ]; then
        TMPFILE=.env.lamp.$$
        #cp .env.lamp. $TMPFILE
        cat .env | sed -e 's/USE_SSL=false/USE_SSL=true/' > $TMPFILE
        mv $TMPFILE .env
    fi
}

_APP_ENV="local"
_USE_SSL="false"
_PLATFORM="local"

#TODO set up support for a sqlite gesture
#this script is initally tuned at updating
# an app that is in place running.

echo "Web Application Build"
# get options parameters or set default into array
if [ "$#" -eq 0 ]; then
  #TODO extra flags for migrate and seed
# perms
  options=( npm composer gulp clearcache env perms htaccess )
  echo "> performing default actions of"
else
  options=( "$@" )
fi

echo "${options[@]}"

pwd

echo "HOSTNAME:"
echo "$HOSTNAME"
case "$HOSTNAME" in 
    "its-dev-lamp-1.ucsc.edu")
    _TIER="dev"
    _APP_ENV="production"
    _USE_SSL="true"
    _PLATFORM="lamp"
    ;;
    "its-stage-lamp-1.ucsc.edu")
    _TIER="stage"
    _APP_ENV="production"
    _USE_SSL="true"
    _PLATFORM="lamp"
    ;;
    "its-prod-lamp-1.ucsc.edu")
    _TIER="prod"
    _APP_ENV="production"
    _USE_SSL="true"
    _PLATFORM="lamp"
    ;;
    *)
    _APP_ENV="local"
    _TIER="local"
    _USE_SSL="false"
    _PLATFORM="local"
    ;;
esac


#always run the .env check and auto-generate feature
if [ -f .env ]; then
    echo ".env file detected, continuing"
else
    echo "creating .env file"
    #determine if we are local or lamp
    createEnv
fi

createStorageDirs


if [[ " ${options[@]} " =~ "sqlitedb" ]]; then
    touch database/database.sqlite
    chmod g+w database/database.sqlite
    if [ "$_PLATFORM" != "local" ] ; then
        chgrp apache9004 database/database.sqlite
    fi

    # if env has mysql change it
    set_sqlite
    echo "completed sqlite setup"

fi

if [[ " ${options[@]} " =~ "npm" ]]; then
    npmver=`npm -v`
    echo "npm version " $npmver;
    loc=`which npm`
    result=$?
    if [ "$result" == 0 ]; then
       echo "> running npm install"
       npm install
       RESULT=$?
       if [ "$RESULT" != 0 ]; then
           echo "ERROR with npm install: result $RESULT"
           exit 1
       fi
   else
       echo "> npm is not installed, continuing"
   fi
fi

if [[ " ${options[@]} " =~ "composer" ]]; then
    loc=`which composer`
    result=$?
    if [ "$result" == 0 ]; then
        echo "> running composer install"
        composer install
        RESULT=$?
        if [ $RESULT != 0 ]; then
            echo "ERROR with composer install: result $RESULT"
            exit 1
        fi
    else
        echo "> composer is not installed, continuing"
    fi
fi

# clean build requires this
if [[ " ${options[@]} " =~ "htaccess" ]]; then
    echo "updating htaccess"
    #update to local folder
    set_htaccess
fi

if [[ " ${options[@]} " =~ "env" ]]; then
    set_env
    if [ "$_USE_SSL" == "true" ];then 
        set_ssl
    fi
fi

if [[ " ${options[@]} " =~ "perms" ]]; then

dirs_to_set_perms="app config cron public resources routes tests"

umask
env


if [[ " ${options[@]} " =~ "clean" ]]; then
    echo "> running clean"
    RESULT=$?
    rm -rf vendor node_modules
    rm -rf public/js
    rm -rf public/css
    rm -rf public/fonts
    rm -rf public/img
    rm -f public/index.php
    rm -f bootstrap/cache/services.php
    if [ $RESULT != 0 ]; then
        echo "ERROR with clean: result $RESULT"
        exit 1
    fi
fi
if [ "${_TIER}" == "dev" ]; then
    echo "> updating perms for dev"
    #account for user with restrictive umask
    chmod -R o+r $dirs_to_set_perms
    chmod o+r *
    chgrp -R its_web_admin $dirs_to_set_perms
    chmod -R gu+w $dirs_to_set_perms
    chmod -R guo+w $dirs_to_set_perms
    chgrp its_web_admin public/.htaccess
fi

if [ "${_TIER}" == "stage" ]; then
    echo "> updating perms for stage"    
    chmod -R o+r $dirs_to_set_perms
    chmod o+r *    
    chgrp -R its_web_admin $dirs_to_set_perms
    chmod -R gu+w $dirs_to_set_perms
    chmod -R guo+w $dirs_to_set_perms
    chgrp its_web_admin public/.htaccess 
fi

if [ "${_TIER}" == "prod" ]; then
    echo "> updating perms for prod"
    chgrp -R its_app_admin $dirs_to_set_perms
    chmod -R gu+w $dirs_to_set_perms
    chmod -R guo+w $dirs_to_set_perms
    chgrp its_app_admin public/.htaccess
fi

chmod guo+r public/.htaccess 

if [[ " ${options[@]} " =~ "perms" ]]; then
    echo "perms only"
else
    rm -f  bootstrap/cache/services.php
fi
if [ "$_PLATFORM" != "local" ] ; then
    chgrp -R apache9004 bootstrap/cache
fi

chmod ug+rwx bootstrap/cache
chmod ug+rw bootstrap/cache/services.php
chmod ug+rw bootstrap/autoload.php

if [ "$_PLATFORM" != "local" ] ; then
    chgrp -R apache9004 storage
fi
if [ ! -f storage/logs/laravel.log ]; then 
    touch storage/logs/laravel.log
fi
chmod ug+rwx storage/logs/laravel.log
if [ "$_PLATFORM" != "local" ] ; then
    chgrp apache9004 storage/logs/laravel.log
fi

fi

if [[ " ${options[@]} " =~ "clearcache" ]]; then
    PHP_PATH=php
    if [ "$_PLATFORM" == "lamp" ]; then
      if [ -f /opt/rh/rh-php70/root/usr/bin/php ]; then
        PHP_PATH=/opt/rh/rh-php70/root/usr/bin/php 
      else
        PHP_PATH=/opt/rh/rh-php56/root/usr/bin/php
      fi 
    fi 
    $PHP_PATH artisan cache:clear
    $PHP_PATH artisan view:clear
fi

if [[ " ${options[@]} " =~ "migrate" ]]; then
    echo "> running datbase migrate"
    php artisan migrate
    RESULT=$?
    if [ $RESULT != 0 ]; then
        echo "ERROR with migrate: result $RESULT"
        exit 1
    fi
fi

if [[ " ${options[@]} " =~ "seed" ]]; then
    echo "> seeding database"
    php artisan db:seed
    RESULT=$?
    if [ $RESULT != 0 ]; then
        echo "ERROR with seed: result $RESULT"
        exit 1
    fi
fi

if [[ " ${options[@]} " =~ "clearcache" ]]; then
    echo "> clearing cache and view"
    php artisan cache:clear
    php artisan view:clear
fi


if [[ " ${options[@]} " =~ "gulp" ]]; then
    loc=`which gulp`
    result=$?
    if [ $RESULT == 0 ]; then
        echo "> running gulp"
        gulp --production
        RESULT=$?
        if [ $RESULT == 0 ]; then
            echo "ERROR with gulp: result $RESULT"
        fi
    else 
        echo "> gulp not found, continuing"
    fi
fi

# note this is built in to gulb
if [[ " ${options[@]} " =~ "phpunit" ]]; then
    echo "> running unit tests"
    ./vendor/bin/phpunit
    RESULT=$?
    if [ $RESULT != 0 ]; then
        echo "ERROR with phpunit: result $RESULT"
        exit 1
    fi
fi

echo "app build completed." 

if [ "$_TIER" == "local" ]; then
  echo "to run application locally, type" 
  echo "php artisan serve"
  echo "which will serve the application as"
  echo "http://localhost:8000"
fi

