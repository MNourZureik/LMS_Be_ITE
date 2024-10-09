<?php

namespace Database\Seeders;

use App\Models\Admin;
use App\Models\Doctor;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Admin::truncate();
        Admin::create([

            'full_name' => 'mahmoud_kamal_borkhsh',
            'email' => 'mahmoud@gmail.com',
            'password' => Hash::make('99999999'),
        ]);
        Admin::create([

            'full_name' => 'mohamed_nour_zoriq',
            'email' => 'mohamed@gmail.com',
            'password' => Hash::make('99999999'),
        ]);$d=5;
    }
}
