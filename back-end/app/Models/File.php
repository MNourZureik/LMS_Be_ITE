<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class File extends Model
{
    use HasFactory;

    protected $table = 'files';
    protected $fillable=
        [ 'file_name',
            'file_path', 'file_type','doctor_id', 'subject_id'];



    public function doctor()
    {
        return $this->belongsTo(Doctor::class,'doctor_id');
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class,'subject_id');
    }

    public function students()
    {
        return $this->belongsToMany(Student::class, 'saved__files');
    }
}
