# Baseapp


## Introduction

Baseapp is a starter web application that is written in Vue on the Client side and Laravel on the server side. It comes with authentication, user management, and a UI theme.


## Requirements

Baseapp has two components, each with its own set of requirements:

### Server

* All requirements by Laravel – PHP, OpenSSL, composer and such. Consider setting PHP's memory_limit to a good value (512M or better) if you have a big library.
* Any database supported by Laravel should work. SQLite, MySQL or MariaDB, PostGRES, and Oracle.
* NodeJS latest stable with yarn

### Client

* Any decent web browser will do – Baseapp has been tested on Chrome 47, Firefox 42, Safari 8, Opera 34, and Edge.


## Installation

From your console, run the following commands:

```
cd PUBLIC_DIR
git clone https://github.com/ucsc/baseapp.git .
git checkout v1.1.0 # Check out the latest version at https://github.com/ucsc/baseapp/releases
composer install
php artisan baseapp:init # Populate credentials during the process
```

`php artisan serve`
You should now be able to visit http://localhost:8000 in your browser and start using Baseapp.

If you want more control, edit .env file. There's quite a few settings there to tweak Baseapp to your needs.


##Update
Check out Releases for upgrade guides corresponding to your Baseapp version.
