<?php

// Route::get('/rlogin/{userid}/{pathname}', function($userid, $pathname) {
//     if (Auth::guest()) {
// 		// Save the attempted URL
// 		Session::put('attempted_url', $pathname);
// 	}
// 	return Redirect::to('login/'.$userid);

// });

Route::get('login/{cruzid}', function () {
    return redirect('/');
})->middleware('login.test');

Route::get('logout', function () {
    return redirect('/');
})->middleware('logout');

Route::get('/', function () {
    return view('index');
});
