<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class student_has_subject extends Model
{
    use HasFactory;


    protected $table='student_has_subjects';
    protected $fillable =[
        'student_id',
        'subject_id',

    ];
}
