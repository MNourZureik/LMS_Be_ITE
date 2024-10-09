<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student_has_Quiz extends Model
{
    use HasFactory;
    protected $table = 'student_has__quizzes';

    protected $fillable = [
        'quiz_id',
        'student_id'
    ];
}
