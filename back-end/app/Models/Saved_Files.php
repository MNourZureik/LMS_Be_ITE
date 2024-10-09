<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Saved_Files extends Model
{
    use HasFactory;

    protected $table='saved__files';
    protected $fillable =[
        'student_id',
        'file_id',


    ];
}
