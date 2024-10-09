<?php

namespace App\Models;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;


class Student extends User  implements ShouldQueue , JWTSubject
{
    use HasFactory, Notifiable;
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */

    protected $table = 'students';
    protected $fillable=[ 'full_name',
        'email',
        'photo','verificationCode'];




    public function subjects()
    {
        return $this->belongsToMany(Subject::class, 'student_has_subjects');
    }
    public function files()
    {
        return $this->belongsToMany(File::class, 'saved__files');
    }
    public function quizzes()
    {
        return $this->belongsToMany(Quiz::class, 'student_has__quizzes');
    }
    public function answers()
    {
        return $this->belongsToMany(Answer::class, 'student_has__answers');
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
