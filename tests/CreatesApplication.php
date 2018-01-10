<?php

namespace Tests;

use App\Models\User;
use Artisan;
use Illuminate\Contracts\Console\Kernel;

trait CreatesApplication
{
    /**
     * The base URL to use while testing the application.
     *
     * @var string
     */
    protected $baseUrl = 'http://localhost';

    /**
     * Creates the application.
     *
     * @return \Illuminate\Foundation\Application
     */
    public function createApplication()
    {
        $app = require __DIR__.'/../bootstrap/app.php';

        $app->make(Kernel::class)->bootstrap();

        return $app;
    }

    private function prepareForTests()
    {
        Artisan::call('migrate');

        if (!User::all()->count()) {
            Artisan::call('db:seed');
        }
    }
}
