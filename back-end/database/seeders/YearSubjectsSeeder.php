<?php

namespace Database\Seeders;

use App\Models\Subject;
use App\Models\Year;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class YearSubjectsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {




        $year1 = Year::create([
            'number_year' => 1,
            'name_year' => 'First year'
        ]);
        $year2 = Year::create([
            'number_year' => 2,
            'name_year' => 'Second year'
        ]);
        $year3 = Year::create([
            'number_year' => 3,
            'name_year' => 'Third year'
        ]);
        $year4 = Year::create([
            'number_year' => 4,
            'name_year' => 'Fourth year'
        ]);
        $year5 = Year::create([
            'number_year' => 5,
            'name_year' => 'Fifth year'
        ]);




        $subjects = [
            //first year
            //1
            ['name_subject' => 'Programming 1', 'year_id' => $year1->id,'subject_type'=>'theoretical'],['name_subject' => 'Programming 1', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'English 1', 'year_id' => $year1->id,'subject_type'=>'theoretical'],
            ['name_subject' => 'Analysis 1', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Analysis 1', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Computer Basics', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Computer Basics', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Generic Algebra', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Generic Algebra', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Physics', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Physics', 'year_id' => $year1->id,'subject_type'=>'practical'],
            //2
            ['name_subject' => 'Programming 2', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Programming 2', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'English 2', 'year_id' => $year1->id,'subject_type'=>'theoretical'],
            ['name_subject' => 'Analysis 2', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Analysis 2', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Arabic', 'year_id' => $year1->id,'subject_type'=>'theoretical'],
            ['name_subject' => 'Linear Algebra', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Linear Algebra', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Electronics', 'year_id' => $year1->id,'subject_type'=>'theoretical'], ['name_subject' => 'Electronics', 'year_id' => $year1->id,'subject_type'=>'practical'],
            ['name_subject' => 'Culture', 'year_id' => $year1->id,'subject_type'=>'theoretical'],


            //Second year
            //1
            ['name_subject' => 'Programming 3', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Programming 3', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'English 3', 'year_id' => $year2->id,'subject_type'=>'theoretical'],
            ['name_subject' => 'Logic Circuits', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Logic Circuits', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'Probabilities and Statistics', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Probabilities and Statistics', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'Algorithms 1', 'year_id' => $year2->id,'subject_type'=>'theoretical'],['name_subject' => 'Algorithms 1', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'Analysis 3', 'year_id' => $year2->id,'subject_type'=>'theoretical'],['name_subject' => 'Analysis 3', 'year_id' => $year2->id,'subject_type'=>'practical'],
            //2
            ['name_subject' => 'English 4', 'year_id' => $year2->id,'subject_type'=>'theoretical'],
            ['name_subject' => 'Algorithms 2', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Algorithms 2', 'year_id' => $year2->id,'teacher_id'=>1,'subject_type'=>'practical'],
            ['name_subject' => 'Numeric Analysis', 'year_id' => $year2->id,'subject_type'=>'theoretical'],['name_subject' => 'Numeric Analysis', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'Communication Skills', 'year_id' => $year2->id,'subject_type'=>'project'],
            ['name_subject' => 'Computer Architecture 1', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Computer Architecture 1', 'year_id' => $year2->id,'subject_type'=>'practical'],
            ['name_subject' => 'Digital Communications', 'year_id' => $year2->id,'subject_type'=>'theoretical'], ['name_subject' => 'Digital Communications', 'year_id' => $year2->id,'subject_type'=>'practical'],
            //third year
            //1
            ['name_subject' => 'Programming Languages', 'year_id' => $year3->id,'subject_type'=>'theoretical'], ['name_subject' => 'Programming Languages', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Computer Networks Basics', 'year_id' => $year3->id,'subject_type'=>'theoretical'], ['name_subject' => 'Computer Networks Basics', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Operations Research', 'year_id' => $year3->id,'subject_type'=>'theoretical'],['name_subject' => 'Operations Research', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Computer Graphics', 'year_id' => $year3->id,'subject_type'=>'theoretical'],['name_subject' => 'Computer Graphics', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Computer Architecture 2', 'year_id' => $year3->id,'subject_type'=>'theoretical'],['name_subject' => 'Computer Architecture 2', 'year_id' => $year3->id,'subject_type'=>'practical'],
            //2
            ['name_subject' => 'Project 1', 'year_id' => $year3->id,'subject_type'=>'project'],
            ['name_subject' => 'Scientific Calculations', 'year_id' => $year3->id,'subject_type'=>'project'],
            ['name_subject' => 'Database 1', 'year_id' => $year3->id,'subject_type'=>'theoretical'],   ['name_subject' => 'Database 1', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Automata', 'year_id' => $year3->id,'subject_type'=>'theoretical'], ['name_subject' => 'Automata', 'year_id' => $year3->id,'subject_type'=>'practical'],
            ['name_subject' => 'Artificial Intelligence Basics', 'year_id' => $year3->id,'subject_type'=>'theoretical'], ['name_subject' => 'Artificial Intelligence Basics', 'year_id' => $year3->id,'subject_type'=>'practical'],


        ];

        foreach ($subjects as $subject) {
            Subject::create($subject);
        }
    }
}
