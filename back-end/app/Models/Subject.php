<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    use HasFactory;
    




    public function year()
    {
        return $this->belongsTo(Year::class);
    }

    public function teacher()
    {
        return $this->belongsTo(Teacher::class);
    }


    public function doctors()
    {
        return $this->belongsToMany(Doctor::class, 'doctor_has_subjects');
    }

    public function students()
    {
        return $this->belongsToMany(Student::class, 'student_has_subjects');
    }

    // public function attachments()
    // {
    //     return $this->hasMany(Attachment::class,'subject_id');
    // }


    public function files() {
        return $this->hasMany(File::class,'subject_id');
    }

    public function quizzes()
    {
        return $this->hasMany(Quiz::class,'subject_id');
    }

    public function notifications() {
        return $this->hasMany(Notification::class,'subject_id');
    }
}
