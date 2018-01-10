<?php

namespace App\Http\Middleware;

use Closure;
use App\Models\User;
use Auth;

class UserAuthTest
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        

        // get the id for routes /fake/{id}
        // example = localhost:8000/login/cruzid
        $fakeid = $request->cruzid;
        // return response()->json(['message' => $fakeid]);

        // if shibboleth returned a valid user
        if (isset($fakeid)) {
            
            // find user in this app
            $user = User::where('name', '=', $fakeid)->first();
            // return response()->json($user);

            // if/else user exists
            if ($user !== NULL){
                // login user
                Auth::login($user);
                $request->session()->put('cruzid', $fakeid);
                // echo Auth::user()->name;
                
            } else {
                // create new user and log them in
                // return response()->json(['message' => 'create']);
                // $user = new User;
                // $user->cruzid = $fakeid;
                // $user->save();


                $user = new User;
                $user->password = bcrypt('password');
                $user->email = $fakeid.'@ucsc.edu';
                $user->name = $fakeid;
                // $user->cruzid = $fakeid;
                $user->save();

                // return response()->json(['message' => 'saved']);

                Auth::login($user);
                $request->session()->put('cruzid', $fakeid);
            }
            
        } else {
            // redirect to 404
            // return redirect('/nope');
            return response()->json(['message' => 'testing']);
        }

        // }

        // return $next($request);

        $response = $next($request);

        $response->header('jwt-token', 'no-cache, must-revalidate');

        return $response;
    }
}
