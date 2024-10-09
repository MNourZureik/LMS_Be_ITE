<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class link extends Model
{
    use HasFactory;
    protected $fillable = [

        'course_id',
        'video_url',
        'video_title',
        'video_time',
    ];

    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
