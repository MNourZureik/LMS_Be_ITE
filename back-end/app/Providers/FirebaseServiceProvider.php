<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;

class FirebaseServiceProvider extends ServiceProvider
{
    /*
    * Register services.
    *
    * @return void
    */
    public function register()
    {
        $this->app->singleton('firebase', function ($app) {
            $factory = (new Factory)
                ->withServiceAccount(config('firebase.credentials'));

            return $factory->create();
        });
    }

    /*
    * Bootstrap services.
    *
    * @return void
    */
    public function boot()
    {
        //
    }
}
