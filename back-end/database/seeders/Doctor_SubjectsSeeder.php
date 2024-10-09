<?php

namespace Database\Seeders;

use App\Models\Doctor;
use App\Models\doctor_has_subject;
use App\Models\Subject;
use Illuminate\Database\Seeder;

class Doctor_SubjectsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {


             $subjects=Subject::all();
             $doctor=Doctor::find(1);

        foreach ($subjects as $subject){
            doctor_has_subject::create([
                'doctor_id'=>$doctor->id,
                'subject_id'=>$subject->id,
            ]);
        }






        $doctore_subjects =
            [
                ['doctor_id' => 7, 'subject_id' => 1],
                ['doctor_id' => 12, 'subject_id' => 8],
                ['doctor_id' => 9, 'subject_id' => 10],
                ['doctor_id' => 14, 'subject_id' => 6],
                ['doctor_id' => 15, 'subject_id' => 4],
                ['doctor_id' => 5, 'subject_id' => 15],
                ['doctor_id' => 20, 'subject_id' => 12],
                ['doctor_id' => 13, 'subject_id' => 18],
                ['doctor_id' => 9, 'subject_id' => 20],
                ['doctor_id' => 21, 'subject_id' => 17],
                ['doctor_id' => 18, 'subject_id' => 23],
            ];


        foreach ($doctore_subjects as $doctore_subject) {

            doctor_has_subject::create($doctore_subject);
        }




    }
}
