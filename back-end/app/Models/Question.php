<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    use HasFactory;

    protected $fillable =
    [
        'question',
        'quiz_id',
    ];

    public function answers()
    {
        return $this->hasMany(Answer::class, 'question_id');
    }

    public function quiz()
    {
        return $this->belongsTo(Quiz::class);
    }

    public function student_answer()
    {
        return $this->hasOne(Student_has_Answer::class, 'question_id');
    }
}
