<?php

namespace Database\Seeders;


use App\Models\Teacher;
use App\Models\Admin;
use App\Models\Doctor;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class TeacherSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        Teacher::create([

            'full_name' => 'somar-tanos',
            'email' => 'somar@gmail.com',
            'password' => Hash::make('99999999'),
        ]);

//        Teacher::create([
//
//            'full_name' => 'sonos',
//            'email' => 'mahmodbrkhsh@gmail.com',
//            'password' => Hash::make('196447'),
//        ]);
    }
}
