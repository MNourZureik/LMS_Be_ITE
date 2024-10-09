<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;


    protected $fillable =
    [
        'title',
        'body',
        'subject_id',
        'created_at'
    ];





    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }
}
