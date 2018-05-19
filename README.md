# Baseapp

## Table of Contents
1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)

## Introduction

Baseapp is a starter web application that is written in Vue on the Client side and Laravel on the server side. It comes with authentication, user management, and UI theme.


## Requirements

Baseapp has two components, each with its own set of requirements:

### Server

* All requirements by Laravel – PHP, OpenSSL, composer and such.
* Any database supported by Laravel should work. SQLite, MySQL or MariaDB, PostGRES or Oracle. Default is SQLite.
* NodeJS latest stable with yarn

### Client

* Any decent web browser will do – Baseapp has been tested on Chrome 47, Firefox 42, Safari 8, Opera 34, and Edge.


## Installation

From your console, run the following commands:

```
cd TO_YOUR_DIR # local or otherwise
git clone https://github.com/ucsc/baseapp.git .
git checkout v0.1.0 # Check out the latest version at https://github.com/ucsc/baseapp/releases
composer install
php artisan baseapp:init # Populate credentials during the process
```

```
php artisan serve
```
You should now be able to visit http://localhost:8000 in your browser and start using Baseapp.

If you want more control, edit .env file. There's quite a few settings there to tweak Baseapp to your needs.


## Update

Check out Releases for upgrade guides corresponding to your Baseapp version.
## Development
1. Run php artisan serve to start the local server (if needed)
2. Run yarn watch to auto-update and compile code while developing
3. Visit localhost:8000/ to view the app
4. Login at localhost:8000/login/your_username
5. Edit the sqlite db users name to make your username an admin to see the user management crud option
