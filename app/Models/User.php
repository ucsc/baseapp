<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

/**
 * @property array  preferences
 * @property int    id
 * @property bool   is_admin
 */
class User extends Authenticatable
{
    use Notifiable;

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'users';

    /**
     * The preferences that we don't want to show to the client.
     *
     * @var array
     */


    /**
     * The attributes that are protected from mass assign.
     *
     * @var array
     */
    protected $guarded = ['id'];

    protected $casts = [
        'id' => 'int',
        'is_admin' => 'bool',
    ];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = ['password', 'remember_token', 'created_at', 'updated_at'];

}
