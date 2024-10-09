<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class doctor_has_subject extends Model
{
    use HasFactory;

    protected $fillable=[
        'doctor_id',
        'subject_id'

    ];
}
