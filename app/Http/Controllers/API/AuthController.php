<?php

namespace App\Http\Controllers\API;

use App\Http\Requests\API\UserLoginRequest;
use Exception;
use Illuminate\Http\JsonResponse;
use JWTAuth;
use Log;
use Tymon\JWTAuth\Exceptions\JWTException;
use Auth;
use Session;

class AuthController extends Controller
{
    /**
     * Log a user in.
     *
     * @param UserLoginRequest $request
     *
     * @return JsonResponse
     */
    public function login(UserLoginRequest $request)
    {
        try {
            if (!$token = JWTAuth::attempt($request->only('email', 'password'))) {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }
        } catch (JWTException $e) {
            Log::error($e);

            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        return response()->json(compact('token'));
    }

    /**
     * Log the current user out.
     *
     * @return JsonResponse
     */
    public function logout()
    {
        Session::flush();

        if ($token = JWTAuth::getToken()) {
            try {
                JWTAuth::invalidate($token);
            } catch (Exception $e) {
                Log::error($e);
            }
        }

        return response()->json();
    }

    /**
     * Check and Log a user in.
     *
     * @param UserLoginRequest $request
     *
     * @return JsonResponse
     */
    public function check()
    {
        if(Auth::guest()) {
            return response()->json(['error' => 'invalid_credentials'], 401);
        }

        try {
            if (!$token=JWTAuth::fromUser(Auth::user())) {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }
        } catch (JWTException $e) {
            Log::error($e);

            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        // Session::flash('token', TRUE);

        return response()->json(compact('token'));

        // if(Auth::guest()) {
        //     return response()->json(['error' => 'invalid_credentials'], 401);
        // } else {
        //     // Session::flash('token', TRUE);
        //     $url = Session::get('attempted_url');
        //     return response()->json(['token' => $url]);
        // }

    }
}
