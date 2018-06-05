#!/bin/bash
# deploy


#move all this code into artisan command
usage() {
  echo "usage: "
  echo "deploy.sh" 
  exit 1
}

runSync() {
  # only need to specify src and dest relative to SOURCE_BASE and DEST_BASE
  # check number of args here. 
  src=$SOURCE_BASE/"$1"
  options="$2"
  this_log=${TMPDIR}/dm_${1}_.log
  #echo $this_log

  dest=$DEST_BASE

  if  [ ! -d $src ] && [ ! -f $src ]; then 
      echo "$src does not exist, continuing"
      return
  fi 

  rsync_cmd="rsync $options $src $dest/"
  echo $rsync_cmd
  #read input 

  $rsync_cmd 2> $this_log
  retVal=$?

  cat $this_log >> $SYNC_LOG

  cat $this_log

  if [ "$retVal" != 0 ]; then
    echo "error with rsync "
    echo "rsync return value is " $retVal
    cat $this_log
    #should we keep going?
  fi

  return $retVal 
}

SYNC_LOG="storage/logs/app_deploy.log"

if [ ! -d storage/logs ]; then
    mkdir -p storage/logs
fi


curDir=`echo $PWD`
#pwd
#echo $curDir
# there may not be an .env for
# example in a jenkins pull 
# we do not build on Jenkins
HASENV=0
if [ -f $curDir/.env ]; then
  source $curDir/.env
  HASENV=1
fi

#Deploy script
#- determine the location of the app, based on the location of the running script (inside the root directory)
# use the convention of the parent directory must be the repo name

echo "App Deployment Utility"
if [ "$TMPDIR" == "" ]; then
  TMPDIR=/tmp
fi
echo "tmpdir is " $TMPDIR

curDir=`echo $PWD`
thisDir=`echo $curDir | rev | cut -d'/' -f 1 | rev`
echo "current directory: " $thisDir
appFolderName=$thisDir
HASGIT=0;
if [ -d ".git" ]; then
  echo ".git file present"
  thisBranchName=`git branch | grep \* | cut -d" " -f2 `
  thisBranchNameNormalized=`git branch | grep \* | cut -d" " -f2 | sed -e 's/\//-/'`
  thisRepoName=`basename $(git remote show -n origin | grep Fetch | cut -d: -f2-) | cut -d\. -f1`
  HASGIT=1
fi

#jenkins provides GIT_BRANCH

# rule is must either have .git or .env
# if not both, bail
#if [ "$HASENV" == 0 ] && [ "$HASGIT" == 0 ] ; then
#fi

SOURCE_BASE="$curDir"

# this is the destination for the dev server only

# if there were no arguments, publish to a user folder with the convention
# of the current folder name to also be published on the LAMP server
# USER-donatemeals where USER is the login name
if [ -d .git ]; then
  thisRepoName=`basename $(git remote show -n origin | grep Fetch | cut -d: -f2-) | cut -d\. -f1`
fi
# dev User on lamp may not match current use. 

if [ "$DEPLOY_USER" == "" ]; then
  echo "please enter use name on LAMP server. (default $USER):"
  #read USER_INPUT
  if [ "$USER_INPUT" != "" ]; then
     DEPLOY_USER="$USER_INPUT"
  else
     DEPLOY_USER="$USER"
  fi
fi 

echo "LAMP user: $DEPLOY_USER"

# the branch name determines the deployment target, unless over-ridden by DEPLOY_HOST
DEPLOY_HOST_SANDBOX="its-dev-lamp-1"
DEPLOY_HOST_DEV="its-dev-lamp-1"
DEPLOY_HOST_STAGE="its-stage-lamp-1"
DEPLOY_HOST_PROD="its-prod-lamp-1"

# if there is no env, assume a jenkins environment
# change this if we ever start to build on jenkins

if [ "$DEPLOY_LOCATION" == "" ]; then
    echo "deploy location not set"
    if [ "$HASENV" == 1 ]; then 
      DEPLOY_LOCATION="/opt/app/apache9004/www/vhosts/lamp9004"
    else
      DEPLOY_LOCATION="/opt/app/apache9004/www/vhosts/"
    fi
fi 

if [ "$DEPLOY_BUILD_TRIGGER" == "" ]; then
  # want to do npm, composer when target is dev only
  # at minimum the build will set perms
  DEPLOY_BUILD_TRIGGER=false
fi 

if [ "$DEPLOY_FOLDER" == "" ]; then
  #different for Jenkins
  if [ "$HASENV" == 0 ]; then # only works for remote builds
    DEPLOY_FOLDER="$thisRepoName"  # instead could use appFolderName
  else 
    #DEPLOY_FOLDER="${DEPLOY_USER}-${appFolderName}"
    #donatemeals" # s.b. thisRepoName
    #DEPLOY_FOLDER="$thisRepoName"  # instead could use appFolderName
    DEPLOY_FOLDER="${DEPLOY_USER}-${thisRepoName}-${thisBranchNameNormalized}"  # instead could use appFolderName
  fi
fi 

# get rid of this
#deployType="lamp"

DEPLOY_HOST_DEV=its-dev-lamp-1.ucsc.edu
DEPLOY_HOST_STAGE=its-dev-lamp-1.ucsc.edu
DEPLOY_HOST_PROD=its-prod-lamp-1.ucsc.edu

DEPLOY_HOST_URL_DEV=its-dev-lamp-1.ucsc.edu
DEPLOY_HOST_URL_STAGE=its-dev-lamp-1.ucsc.edu
DEPLOY_HOST_URL_PROD=its-prod-lamp-1.ucsc.edu

if [ "$HASGIT" == 1 ]; then 
#check that target name matches repo/app name
# should also ensure that thisBranchName is set
echo "git repo: " $thisRepoName
echo "git branch: " $thisBranchName

#check that target name matches repo/app name

case $thisBranchName in
    "develop")
        DEPLOY_TARGET="dev"
        if [ "$DEPLOY_HOST" == "" ]; then
		      DEPLOY_HOST="$DEPLOY_HOST_DEV"
        fi
        if [ "$DEPLOY_HOST" == "$DEPLOY_HOST_DEV" ]; then 
            theURL="https://donatemeals-dev.ucsc.edu"
        fi 
		;;
    "master")
	    DEPLOY_TARGET="stage"
        if [ "$DEPLOY_HOST" == "" ]; then
		      DEPLOY_HOST="$DEPLOY_HOST_STAGE"
        fi
        if [ "$DEPLOY_HOST" == "$DEPLOY_HOST_STAGE" ]; then 
            theURL="https://donatemeals-stage.ucsc.edu"
        fi 
		;;
    "release")
	    DEPLOY_TARGET="prod"
        if [ "$DEPLOY_HOST" == "" ]; then
		      DEPLOY_HOST="$DEPLOY_HOST_PROD"
        fi
        if [ "$DEPLOY_HOST" == "$DEPLOY_HOST_PROD" ]; then 
            theURL="https://donatemeals.ucsc.edu"
        fi 
		;;
    "")
      echo "error, no branch"
      exit
    ;;
    *)
        # TODO filter out feature branches. 
        #must be a user sandbox. 
        DEPLOY_TARGET="dev"
        if [ "$DEPLOY_HOST" == "" ]; then
	        DEPLOY_HOST="$DEPLOY_HOST_SANDBOX"
        fi
        if [ "$DEPLOY_HOST" == "its-dev-lamp-1" ]; then 
            theURL="https://lamp9004-dev.ucsc.edu/$DEPLOY_FOLDER"
        fi 
	    ;; 
esac
#end case of having a .git file
fi

echo "Deploying from "
echo " $SOURCE_BASE "
echo "to"
echo " $DEPLOY_HOST:$DEPLOY_LOCATION/$DEPLOY_FOLDER"
echo ""

echo "ctrl-c to quit, return to continue"
#read input
# need to update .env file to USE_SSL=true

DEST_BASE="$DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_LOCATION/$DEPLOY_FOLDER"

echo $SOURCE_BASE
echo $DEST_BASE

#exit

# rsync will prompt for user’s lamp password (you shouldn’t have to add this)
# add ssh key in order to authenticate instead of  password prompt

# can not exclude config/app.php, database.php. write only if does not exist
# the ignore existing flag indicates not to over-write an existing file, but copy if not there yet
# folders with special rules
# it is arguable that we should publish config at all on a LAMP server
runSync 'config'  '-a --ignore-existing config/app.php --ignore-existing config/database.php' 

#perform the sync of vendor and node_modules first. 
# run the directories that require pruning first. 
# consider making -a --delete after the default if no agr provided
rsync -a vendor node_modules resources app ${DEST_BASE}/

runSync 'public' '-a --delete-after --exclude public/import'
runSync 'routes' '-a --delete-after'

# do not prune bootstrap
runSync 'bootstrap' '-a'

# the dirs below do not affect the runtime app
# we should just let the build script create the sqlite if not already
# however a developer may wish to push a db. provide an option for this
# as well as whether to seed the database. 
options='-a --delete-after --exclude database/database.sqlite'
# if [ "${deployType}" != "sandbox" ]; then
#     other_options="--exclude database/database.sqlite"
# else
#     other_options="--ignore-existing database/database.sqlite"
# fi
runSync 'database' $options 

runSync 'tests' '-a --delete-after'


#review
runSync 'cron' '-a --ignore-existing'

#only create the storage dir if it does not exist do not recurse. 
#this command actually only creates and sets perms on an empty dir
#
runSync 'storage' '-lptgoD --ignore-existing storage'

# run the sync at the top level now
# should not need .git or .gitattributes would be good to publish branch and revision info somewhere
# we do not need to exclude the dirs as it is not recursive
#options='--exclude .git --exclude .gitattributes'
#  --exclude storage --exclude config "

# better just to never copy env and let it be part of the build step
# if [ "${deployType}" != "sandbox" ]; then
#     other_options=' --exclude .env '
# else
#     other-options='--ignore-existing .env '
# fi
# this flag specifies to not recurse (no -r)
#options='-lptgoD --exclude .git --exclude .gitattributes --exclude .env'
# do we really need the /
#runSync '/' $options
# rsync_cmd="rsync -lptgoD $options $src/* $dest"
# # dev: let the user view the command before we run it for proofreading
# echo $rsync_cmd"\n"
# $rsync_cmd
# retVal=$?
# echo "rsync return value is " $retVal

# for now, hand pick which top level scripts get deployed
# make this a data list in a config files, fabric style

runSync 'index.php' '-ptgoD'
runSync 'server.php' '-ptgoD'
runSync 'artisan' '-ptgoD'
runSync 'package.json' '-ptgoD'
runSync 'composer.json' '-ptgoD'
runSync 'gulpfile.js' '-ptgoD'
runSync 'deploy.sh' '-ptgoD'
runSync 'build.sh' '-ptgoD'
#runSync 'public/favicon.ico' '-ptgoD'

runSync 'readme.md' '-ptgoD'
#designed to be set up one time only
runSync '.htaccess' '-ptgoD --ignore-existing'

runSync 'webpack.mix.js' '-ptgoD'
runSync 'phpunit.xml' '-ptgoD'
runSync 'nitpick.json' '-ptgoD'
runSync 'LICENSE.md' '-ptgoD'
runSync 'yarn.lock' '-ptgoD'
runSync 'webpack.mix.js' '-ptgoD'

runSync '.env.lamp'  '-ptgoD'
runSync '.env.localhost'  '-ptgoD'

runSync '.env.example'  '-ptgoD'
runSync 'package-lock.json' '-ptgoD'
runSync 'composer.lock' '-ptgoD'

#only if not there
#runSync '.htaccess' '-ptgoD'

ssh $DEPLOY_USER@$DEPLOY_HOST "cd $DEPLOY_LOCATION/$DEPLOY_FOLDER; PATH=/opt/rh/rh-php70/root/usr/bin:$PATH; rm -f bootstrap/cache/config.php"
ssh $DEPLOY_USER@$DEPLOY_HOST "cd $DEPLOY_LOCATION/$DEPLOY_FOLDER; PATH=/opt/rh/rh-php70/root/usr/bin:$PATH; php artisan config:clear"
#ssh $DEPLOY_USER@$DEPLOY_HOST "cd $DEPLOY_LOCATION/$DEPLOY_FOLDER; PATH=/opt/rh/rh-php70/root/usr/bin:$PATH; php artisan cache:clear"
ssh $DEPLOY_USER@$DEPLOY_HOST "cd $DEPLOY_LOCATION/$DEPLOY_FOLDER; PATH=/opt/rh/rh-php70/root/usr/bin:$PATH; php artisan baseapp:init"

ssh $DEPLOY_USER@$DEPLOY_HOST "cd $DEPLOY_LOCATION/$DEPLOY_FOLDER; PATH=/opt/rh/rh-php70/root/usr/bin:$PATH; /bin/sh php artisan app:build --perms"

if [ "$theURL" != "" ]; then
    echo "URL is"
    echo $theURL
fi
