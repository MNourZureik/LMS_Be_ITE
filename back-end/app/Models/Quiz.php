<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Quiz extends Model
{

    use HasFactory;

    protected $fillable =
    [
        'doctor_id', 'teacher_id', 'subject_id', 'type',
        'time',
        'level',
        'num_question',
    ];

    public function questions()
    {
        return $this->hasMany(Question::class,'quiz_id');
    }
    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
    public function teacher()
    {
        return $this->belongsTo(Teacher::class);
    }

    public function students()
    {
        return $this->belongsToMany(Student::class, 'student_has__quizzes');
    }
}
