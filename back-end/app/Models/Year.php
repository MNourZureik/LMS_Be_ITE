<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Year extends Model
{
    use HasFactory;
protected $table='years';
    public function subjects()
    {
        return $this->hasMany(Subject::class,'year_id');
    }
}
