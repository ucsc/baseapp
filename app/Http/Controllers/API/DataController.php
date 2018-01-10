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
        // $playlists = Playlist::byCurrentUser()->orderBy('name')->with('songs')->get()->toArray();

        // We don't need full song data, just ID's
        // foreach ($playlists as &$playlist) {
        //     $playlist['songs'] = array_pluck($playlist['songs'], 'id');
        // }

        return response()->json([
            // 'settings' => $request->user()->is_admin ? Setting::pluck('value', 'key')->all() : [],
            // 'playlists' => $playlists,
            // 'interactions' => Interaction::byCurrentUser()->get(),
            'users' => $request->user()->is_admin ? User::all() : [],
            'currentUser' => $request->user(),
            // 'allowDownload' =>  config('baseapp.download.allow'),
            // 'cdnUrl' => app()->staticUrl(),
            // 'currentVersion' => Application::BASEAPP_VERSION,
            // 'latestVersion' => $request->user()->is_admin ? app()->getLatestVersion() : Application::BASEAPP_VERSION,
        ]);
    }
}
