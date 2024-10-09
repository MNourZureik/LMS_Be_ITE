<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\File;
use App\Models\Subject;
use App\Models\Teacher;
use App\Models\Year;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;

class YearController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function year_subjects_theoretical($id)
    {
        //$year=Year::findorfail($id);
        $year = Year::with(['subjects' => function ($query) {
            $query->where('subject_type', 'theoretical')->with('doctors:full_name');
        }])->find($id);
        // التأكد من وجود السنة وإرجاع البيانات المرتبطة بها
        if ($year) {
            $subjects = $year->subjects->map(function ($subject) {
                return [
                    'id' => $subject->id,
                    'name' => $subject->name_subject,
                    'doctors' => $subject->doctors->pluck('full_name')
                ];
            });

            return $this->handleResponse($subjects, null, 200);
        }
        return $this->handleResponse(null, 'Year not found', 404);
    }

    public function year_subjects_practical($id)
    {


        $year = Year::with(['subjects' => function ($query) {
            $query->where('subject_type', 'practical');
        }])->find($id);
        // التأكد من وجود السنة وإرجاع البيانات المرتبطة بها
        if ($year) {
            $subjects = $year->subjects->map(function ($subject) {
                $teacherName = optional($subject->teacher)->full_name;
                return [
                    'id' => $subject->id,
                    'name' => $subject->name_subject,
                    'teacher' => $teacherName
                ];
            });

            return $this->handleResponse($subjects, null, 200);
        }
        return $this->handleResponse(null, 'Year not found', 404);
    }

    public function get_files_names(Request $request)
    {
        $validator = Validator::make($request->all(), [


            'year_id' => 'required|exists:years,id',
            'subject_id' => 'required|exists:subjects,id',
            'file_type' => 'required|exists:files,file_type',


        ]);


        if ($validator->fails()) {
            return $this->handleResponse(null, '', 403);
        }

        $year = Year::findorfail($request->year_id);


        $subject = $year->subjects()->where('id', $request->subject_id)->first();


        $files_names = $subject->files()->where('file_type', $request->file_type)->get(['id', 'file_name' , 'file_path']);


        return $this->handleResponse($files_names, '', 200);
    }

    // public function get_files(Request $request)
    // {
    //     $validator = Validator::make($request->all(), [


    //         'year_id' => 'required|exists:years,id',
    //         'subject_id' => 'required|exists:subjects,id',
    //         'file_id' => 'required|exists:files,id',


    //     ]);


    //     if ($validator->fails()) {
    //         return response()->json([
    //             'errors' => $validator->errors(),
    //         ], 400);
    //     }

    //     $year = Year::findorfail($request->year_id);


    //     $subject = $year->subjects()->where('id', $request->subject_id)->first();


    //     $file = $subject->files()->where('id', $request->file_id)->first();

    //     if ($file) {
    //         $filePath =  "http://10.0.2.2:8000/" . $file->file_path;
    //         return $this->handleResponse($filePath, null, 200);
    //     }
    //     return $this->handleResponse(null, 'File not found.', 404);
    // }

    // public function download_files($id)
    // {

    //     $file = File::findorfail($id);

    //     if ($file) {
    //         $filePath = $file->file_path;
    //         return response()->download($filePath, $file->id);
    //     }
    //     return $this->handleResponse(null, 'File not found.', 404);
    // }
}
