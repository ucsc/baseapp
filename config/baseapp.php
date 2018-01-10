<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Admin Credentials
    |--------------------------------------------------------------------------
    |
    | When running `php artisan baseapp:init` the admin is set using the .env
    |
    */

    'admin' => [
        'name' => env('ADMIN_NAME'),
        'email' => env('ADMIN_EMAIL'),
        'password' => env('ADMIN_PASSWORD'),
    ],

    /*
    |--------------------------------------------------------------------------
    | CDN
    |--------------------------------------------------------------------------
    |
    |
    |
    */

    'cdn' => [
        'url' => env('CDN_URL'),
    ],

    /*
    |--------------------------------------------------------------------------
    | Ignore Dot Files
    |--------------------------------------------------------------------------
    |
    | Ignore dot files and folders when scanning for media files.
    |
    */
    'ignore_dot_files' => env('IGNORE_DOT_FILES', true),

    'itunes' => [
        'enabled' => env('USE_ITUNES', true),
        'affiliate_id' => '1000lsGu',
    ],

    'cache_media' => env('CACHE_MEDIA', true),

    'memory_limit' => env('MEMORY_LIMIT'),

    'misc' => [
        'home_url' => 'https://www.ucsc.edu/',
        'docs_url' => 'https://www.ucsc.edu/',
    ],

];
