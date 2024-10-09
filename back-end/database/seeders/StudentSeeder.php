<?php

namespace Database\Seeders;

use App\Models\Student;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class StudentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        Student::create([

            'full_name' => 'mohamd-alabbar',
            'email' => 'mahmowdaaa@gmail.com',
            'password' => Hash::make('99999999'),
        ]);
    }
}
