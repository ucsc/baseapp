<?php

use Illuminate\Http\Request;

Route::group(['namespace' => 'API'], function () {
    Route::post('me', 'AuthController@login');
    Route::delete('me', 'AuthController@logout');
    Route::get('check', 'AuthController@check');

    Route::group(['middleware' => 'jwt.auth'], function () {
        Route::get('/', function () {
            // Just acting as a ping service.
        });

        Route::post('broadcasting/auth', function (Request $request) {
            $pusher = new Pusher(
                config('broadcasting.connections.pusher.key'),
                config('broadcasting.connections.pusher.secret'),
                config('broadcasting.connections.pusher.app_id'),
                [
                    'cluster' => config('broadcasting.connections.pusher.options.cluster'),
                    'encrypted' => true,
                ]
            );

            return $pusher->socket_auth($request->channel_name, $request->socket_id);
        });

        Route::get('data', 'DataController@index');

        // User and user profile routes
        Route::resource('user', 'UserController', ['only' => ['store', 'update', 'destroy']]);
        Route::get('me', 'ProfileController@show');
        Route::put('me', 'ProfileController@update');

        
    });

    Route::group(['middleware' => 'os.auth', 'prefix' => 'os', 'namespace' => 'ObjectStorage'], function () {
        Route::group(['prefix' => 's3', 'namespace' => 'S3'], function () {
            // we follow AWS's convention here.
        });
    });
});
