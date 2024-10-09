<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student_has_Answer extends Model
{
    use HasFactory;
    protected $table = 'student_has__answers';
    protected $fillable = [
        'answer_id',
        'student_id',
        'question_id',

    ];

    public function question()
    {
        return $this->belongsTo(Question::class);
    }
}
