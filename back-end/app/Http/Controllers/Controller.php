<?php

namespace App\Http\Controllers;

use App\Models\Student;

use App\Models\Notification;
use App\Models\Subject;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

use App\Services\firebase;


class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    protected $firebaseService;

    public function __construct(firebase $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    protected function notifyStudents(int $subjectId, string $message)
    {

        $subject = Subject::find($subjectId);
        $students = $subject->students;

        //! store notification
        Notification::create([
           'title'=> $subject->name_subject,
           'body'=> $message,
           'subject_id'=> $subject->id,
        ]);


        foreach ($students as $student) {
            if ($student->fcm_token)
                $this->firebaseService->sendMessage($student->fcm_token, $subject->name_subject, $message);
        }
    }
    protected function notifyStudentsAll(string $course_name, string $message)
    {
        //! store notification
        Notification::create([
            'title'=> $course_name,
            'body'=> $message,
         ]);


        $students = Student::all();
        foreach ($students as $student) {
            if ($student->fcm_token)
                $this->firebaseService->sendMessage($student->fcm_token, $course_name, $message);
        }
    }
    public function handleResponse($data = null, $message = null, $status = null): \Illuminate\Foundation\Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\Routing\ResponseFactory
    {
        $array = [
            'data' => $data,
            'message' => $message,
            'status' => $status,
        ];
        return response($array);
    }
}
