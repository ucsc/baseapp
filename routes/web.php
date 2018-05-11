<?php

// Route::get('/rlogin/{userid}/{pathname}', function($userid, $pathname) {
//     if (Auth::guest()) {
// 		// Save the attempted URL
// 		Session::put('attempted_url', $pathname);
// 	}
// 	return Redirect::to('login/'.$userid);

// });

if (env('APP_ENV') == "local") {
    // use this version for local development testing only
Route::get('login/{cruzid}', function () {
    return redirect('/');
})->middleware('login.test');
} else {
    // use this version on a production server
    Route::get('login', function () {
    })->middleware('login');
}

Route::get('logout', function () {
    return redirect('/');
})->middleware('logout');

Route::get('/', function () {
    return view('index');
});
