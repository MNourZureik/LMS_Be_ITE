<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class course extends Model
{
    use HasFactory;

    protected $fillable = [
        'course_name',
        'auther_name',
        'discreption',
        'photo'

    ];

    public function links()
    {
        return $this->hasMany(link::class, 'course_id');
    }
}
