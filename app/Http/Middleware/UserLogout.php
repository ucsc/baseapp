<?php

namespace App\Http\Middleware;

use Closure;
use Session;

class UserLogout
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
        $request->session()->flush();
        Session::flush();
        
        return $next($request);
    }
}
