<?php

namespace App\Http\Controllers\Wep;

use App\Services\firebase;

use App\Http\Controllers\Controller;

use App\Models\course;
use App\Models\Doctor;
use App\Models\doctor_has_subject;
use App\Models\link;
use App\Traits\ValidationTrait;
use App\Traits\UploadImageTrait;
use App\Models\Student;
use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;


class AdminsController extends Controller
{



    use UploadImageTrait;
    use ValidationTrait;
    public function logout()
    {
        auth('admin')->logout();
        return $this->handleResponse(null, "admin logged out successfully", 200);
    } //ok

    //register  doctor
    public function registerdoctor(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required',
            'email' => 'required|unique:doctors,email',

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        $doctor = doctor::create([
            'full_name' => $request->full_name,
            'email' => $request->email,

        ]);




        $data = [];
        $data['doctor'] = $doctor;
        return $this->handleResponse($data, 'doctor  registered successfully', 201);
    } //ok

    //register  teacher
    public function registerteacher(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required',
            'email' => 'required|unique:teachers,email',

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        $teacher = teacher::create([
            'full_name' => $request->full_name,
            'email' => $request->email,


        ]);




        $data = [];
        $data['teacher'] = $teacher;
        return $this->handleResponse($data, 'teacher  registered successfully', 201);
    } //ok

    //register  student
    public function registerstudent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required',
            'email' => 'required|unique:students,email',
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        $student = Student::create([
            'full_name' => $request->full_name,
            'email' => $request->email,

        ]);



        $data = [];
        $data['student'] = $student;
        return $this->handleResponse($data, 'student  registered successfully', 201);
    } //ok

    public function delete_student(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        $student = Student::where('email', $request->email)->first();
        if (!$student)
            return $this->handleResponse(null, '', 404);
        $student->delete();
        return $this->handleResponse(null, '', 200);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required'],
            'password' => ['required', 'string', 'min:8']
        ]);
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        try {
            $token = auth('admin')->attempt($request->only('email', 'password'));


            if (!$token) {
                return $this->handleResponse(null, "wrong email or password", 400);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $admin = auth('admin')->user();
        $data = [];
        $data['admin'] = $admin;
        $data['token'] = $token;
        return $this->handleResponse($data, "admin logged in successfully", 200);
    } //ok

    public function resetpassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'old_password' => ['required'],
            'new_password' => ['required', 'string', 'min:8'],
            'confirm_password' => ['required', 'string', 'min:8']
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        if ($request->new_password == $request->confirm_password) {
            $email = auth('admin')->user()->email;

            $dataAtemp = array(
                'email' => $email,
                'password' => $request->old_password,
            );
            try {
                $token = auth('admin')->attempt($dataAtemp);
                if (!$token) {
                    return $this->handleResponse(null, "wrong  password", 400);
                }
                $teacher = auth('admin')->user();
                $teacher->password = $request->new_password;
                $teacher->save();
            } catch (JWTException $e) {
                return $this->handleResponse(null, "Failed  please try again.", 500);
            }
            return $this->handleResponse(null, "admin reset password successfully", 200);
        }
        return $this->handleResponse(null, "check that the new password maches the confirm password", 401);
    } //ok








    public function add_course(Request $request)
    {

        $data = json_decode($request->getContent(), true);

        $validator = $this->validateCourseData($data);


        if ($validator->fails()) {
            return $this->handleResponse(null, $validator->errors()->first(), 400);
        }

        $path = $this->uploadimageFromBytes($data, $data['image_name']);
        $course = Course::create([
            'course_name' => $data['course_name'],
            'auther_name' => $data['auther_name'],
            'discreption' => $data['discreption'],
            'photo' => $path,
        ]);

        foreach ($data['links'] as $linkData) {
            $this->createLink($course->id, $linkData);
        }
        $this->notifyStudentsAll($course->course_name, "New Course Uploaded");
        return $this->handleResponse(null, "Course added successfully", 200);
    }
    public function get_course_info($course_id)
    {
        // البحث عن الدورة باستخدام ID
        $course = Course::with('links')->findOrFail($course_id);

        // تنسيق البيانات للـ response
        return  $courseData = [
            'course_name' => $course->course_name,
            'auther_name' => $course->auther_name,
            'discreption' => $course->discreption,
            'photo' => $course->photo,
            'links' => $course->links->map(function ($link) {
                return [
                    'video_url' => $link->video_url,
                    'video_title' => $link->video_title,
                    'video_time' => $link->video_time,
                ];
            }),
        ];
    }
    public function show_courses()
    {
        $courses = Course::all();

        $courses = $courses->map(function ($course) {
            return $this->get_course_info($course->id);
        });
        return $this->handleResponse($courses, '', 200);
    }
    public function delete_course(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'course_name' => 'required|exists:courses,course_name',

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        $course = course::where('course_name', $request->course_name)->first();
        if (!$course)
            return $this->handleResponse(null, '', 404);

        $course->delete();
        $this->notifyStudentsAll($course->course_name, "New Course Deleted");
        return $this->handleResponse(null, '', 200);
    }






    public function subjects_theoretical()
    {
        $subjects = Subject::select('id', 'name_subject', 'year_id', 'teacher_id')->where('subject_type', 'theoretical')->get();
        $data = $subjects->map(function ($subject) {
            return [
                'subject_id' => $subject->id,
                'name_subject' => $subject->name_subject,
                'year' => $subject->year->name_year,
                'doctors' => $subject->doctors->select('id', 'full_name', 'email'),
            ];
        });

        return $this->handleResponse($data, '', 200);
    }
    public function subjects_practical()
    {
        $subjects = Subject::select('id', 'name_subject', 'year_id', 'teacher_id')->where('subject_type', 'practical')->get();
        $data = $subjects->map(function ($subject) {
            $teacher_info = $subject->teacher()->first();
            if ($teacher_info)
                $teacher_info = Teacher::where('id', $teacher_info->id)->select('id', 'full_name', 'email')->get();
            else {
                $teacher_info = null;
            }

            return [
                'subject_id' => $subject->id,
                'name_subject' => $subject->name_subject,
                'year' => $subject->year->name_year,
                'doctor' => $subject->doctors->map(function ($teacher) {
                    return [
                        'id' => $teacher->id,
                        'full_name' => $teacher->full_name,
                        'email' => $teacher->email,
                    ];
                }),

                'teacher' => $teacher_info,
            ];
        });

        return $this->handleResponse($data, '', 200);
    }
    public function appointment_teacher(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'subject_id' => 'required|exists:subjects,id'
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);



        $teacher = Teacher::where('email', $request->email)->first();
        if (!$teacher) {
            return $this->handleResponse(null, 'teacher not found', 404);
        }


        $subject = Subject::where('id', $request->subject_id)->first();
        if (!$subject) {
            return $this->handleResponse(null, 'subject not found', 404);
        }
        if ($subject->subject_type === 'theoretical')
            return $this->handleResponse(null, 'the subject is theoretical', 400);

        return  $subject->doctors;
        if (!$subject->teacher && !$subject->doctors) {
            $subject->teacher_id = $teacher->id;
            $subject->save();
            return $this->handleResponse(null, ' teacher appointment successfully', 201);
        } else {

            return $this->handleResponse(null, 'subject has teacher or doctor', 401);
        }
    } //ok
    public function appointment_doctor(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'subject_id' => 'required|exists:subjects,id'
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);



        $doctor = doctor::where('email', $request->email)->first();
        if (!$doctor) {
            return $this->handleResponse(null, 'doctor not found', 404);
        }


        $subject = Subject::where('id', $request->subject_id)->first();
        if (!$subject) {
            return $this->handleResponse(null, 'subject not found', 404);
        }

        $doc_sub = doctor_has_subject::where('doctor_id', $doctor->id)->where('subject_id', $subject->id)->first();
        if ($doc_sub) {
            return $this->handleResponse(null, 'doctor already has this subject', 404);
        }

        doctor_has_subject::create([
            'doctor_id' => $doctor->id,
            'subject_id' => $subject->id
        ]);



        return $this->handleResponse(null, ' doctor appointment successfully', 201);
    } //ok
    public function cancel_teacher_for_subject(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'subject_id' => 'required|exists:subjects,id'
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        $doctor = Doctor::where('email', $request->email)->first();
        $teacher = Teacher::where('email', $request->email)->first();
        if (!$teacher && !$doctor) {
            return $this->handleResponse(null, 'teacher not found', 404);
        }


        $subject = Subject::where('id', $request->subject_id)->first();
        if (!$subject) {
            return $this->handleResponse(null, 'subject not found', 404);
        }
        if ($subject->subject_type === 'theoretical')
            return $this->handleResponse(null, 'the subject is theoretical', 400);
        if (!$subject->teacher  && !$subject->doctors) {

            return $this->handleResponse(null, 'subject has not teacher ', 401);
        } else {

            if($doctor)
            {
                $doctor = doctor_has_subject::where('doctor_id', $doctor->id)->where('subject_id', $subject->id)->first();
                $doctor->delete();
                return $this->handleResponse(null, ' doctor canceled successfully', 200);

            }
            elseif($teacher){
            $subject->teacher_id = null;
            $subject->save();
            return $this->handleResponse(null, ' teacher canceled successfully', 200);
            }
        }
    }
    public function cancel_doctor_for_subject(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required',
            'subject_id' => 'required|exists:subjects,id'
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);



        $doctor = doctor::where('email', $request->email)->first();
        if (!$doctor) {
            return $this->handleResponse(null, 'teacher not found', 404);
        }


        $subject = Subject::where('id', $request->subject_id)->first();
        if (!$subject) {
            return $this->handleResponse(null, 'subject not found', 404);
        }
        if (!$subject->doctors) {
            return $this->handleResponse(null, 'subject has not doctor ', 401);
        } else {
            $doctor = doctor_has_subject::where('doctor_id', $doctor->id)->where('subject_id', $subject->id)->first();
            $doctor->delete();
            return $this->handleResponse(null, ' doctor canceled successfully', 200);
        }
    }
}
