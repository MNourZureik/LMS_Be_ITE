<?php

namespace Database\Seeders;

use App\Models\Admin;
use App\Models\Doctor;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DoctorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {






        $doctors=
        [
            ['full_name' => $name='mahmodbrkhsh','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Wesam_Alkhateb','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Huda_Habash','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='AubaiSundouk','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Abdullah_Alomar','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Alaa_Alhomsi','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Medhat_Alsous','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],//*
            ['full_name' => $name='Nawras_Watfeh','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Fatima Khodr','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='KhozamaAmmar','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='RawanKoroni','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='ImadAldeenMohammed','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Asmahan_Khadour','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Farah Hamshou','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Mohannad Bakr','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='KhaolaAlali','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='AmmarAlnahhas','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='MohammedAlahmed','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='KhaledAlomar','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Feras Daeef','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
            ['full_name' => $name='Samer Zayood','email' => $name.'@gmail.com','password' => Hash::make('99999999'),],
        ];


        foreach ($doctors as $doctor) {
            Doctor::create($doctor);
        }
    }

}
