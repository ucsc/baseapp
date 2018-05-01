<?php

namespace App\Http\Controllers\API;

use App\Application;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DataController extends Controller
{
    /**
     * Get a set of application data.
     *
     * @param Request $request
     *
     * @return JsonResponse
     */
    public function index(Request $request)
    {
        return response()->json([
            'users' => $request->user()->is_admin ? User::all() : [],
            'currentUser' => $request->user(),
        ]);
    }
}
