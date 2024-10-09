<?php

namespace App\Models;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;


class Doctor  extends User  implements ShouldQueue , JWTSubject
{
    use HasFactory, Notifiable;

    protected $table = 'doctors';
    protected $fillable=
        [ 'full_name',
        'email',
        'photo','verificationCode'];



    public function files()
    {
        return $this->hasMany(File::class,'doctor_id');
    }

    public function quizzes()
    {
        return $this->hasMany(Quiz::class,'doctor_id');
    }







    public function subjects()
    {
        return $this->belongsToMany(Subject::class, 'doctor_has_subjects');
    }








    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',

    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',

    ];

    public function getJWTIdentifier()
    {
        return $this->getKey(); // Assuming your admin model has a primary key called "id".
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }


}
