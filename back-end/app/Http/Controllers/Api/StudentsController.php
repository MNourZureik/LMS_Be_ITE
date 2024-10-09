<?php

namespace App\Http\Controllers\Api;


use App\Models\File;
use App\Models\Saved_Files;
use App\Models\Student;
use App\Models\Subject;
use App\Traits\UploadImageTrait;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\student_has_subject;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;

class StudentsController extends Controller
{
    use UploadImageTrait;

    public function LogOut()
    {
        auth('student')->logout();
        return $this->handleResponse(null, "student logged out successfully", 200);
    }

    function register_fcm_token(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fcm_token' => ['required']
        ]);
        if ($validator->fails()) {
            return $this->handleError($validator->errors());
        }
       
        $student = auth('student')->user();

        if ($student) {
            $student->fcm_token = $request->fcm_token;
            $student->save();
            return $this->handleResponse(null, null, 200);
        }
        return $this->handleResponse(null, null, 400);
    }

    public function SetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [

            'password' => ['required', 'string', 'min:8'],
            'confirm_password' => ['required', 'string', 'min:8']
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        if ($request->password == $request->confirm_password) {
            $student = auth('student')->user();
            $student->password = $request->password;
            $student->save();
            return $this->handleResponse(null, "student set password successfully", 200);
        }
        return $this->handleResponse(null, "check that the password maches the confirm password", 401);
    } //ok ok

    public function ResetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'old_password' => ['required', 'string', 'min:8'],
            'new_password' => ['required', 'string', 'min:8'],
            'confirm_password' => ['required', 'string', 'min:8']

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);
        if ($request->new_password == $request->confirm_password) {
            $email = auth('student')->user()->email;

            $dataAtemp = array(
                'email' => $email,
                'password' => $request->old_password,
            );
            try {
                $token = auth('student')->attempt($dataAtemp);
                if (!$token) {
                    return $this->handleResponse(null, "wrong  password", 400);
                }
                $student = auth('student')->user();
                $student->password = $request->new_password;
                $student->save();
            } catch (JWTException $e) {
                return $this->handleResponse(null, "Failed  please try again.", 500);
            }
            return $this->handleResponse(null, "student reset password successfully", 200);
        }
        return $this->handleResponse(null, "check that the new password maches the confirm password", 401);
    } //ok

    public function Edit_student_photo(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'photo' => 'required|image|mimes:jpeg,png,jpg',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
            ], 400);
        }
        $userId = auth('student')->user()->id;
        if ($request->hasFile('photo')) {
            $path = $this->uploadimage($request, 'doctors');
            Student::where('id', $userId)->Update([
                'photo' => 'http://127.0.0.1:8000/' . $path,
            ]);
            return $this->handleResponse(null, 'photo Edited successfully', 200);
        }

        return $this->handleResponse(null, 'No photo uploaded', 400);
    }

    public function get_student_photo()
    {
        $userId = auth('student')->user()->id;
        $student_photo = Student::where('id', $userId)->first()->photo;
        return $this->handleResponse($student_photo, '', 200);
    }

    public function student_subjects_theoretical()
    {
        $user = auth('student')->user();
        $data = $user->subjects()->where('subject_type', 'theoretical')->get();
        return $this->handleResponse($data, '', 200);
    }

    public function student_subjects_practical()
    {
        $user = auth('student')->user();
        $data = $user->subjects()->where('subject_type', 'practical')->get();
        return $this->handleResponse($data, '', 200);
    }

    public function add_to_my_subjects(Request $request)
    {

        $user = auth('student')->user();

        $subjectId = $request->subject_id;

        $subject = Subject::where('id', $subjectId)->first();

        if (!$subject) {
            return $this->handleResponse(null, null, 404);
        }
        if ($subject->subject_type == 'theoretical') {
            $user->subjects()->syncWithoutDetaching($subjectId);
            student_has_subject::where('subject_id', $subject->id)->update([
                'status_subject' => '1',
            ]);
        }
        if ($subject->subject_type == 'practical') {
            $subject_th_id = Subject::where('subject_type', 'theoretical')->where('name_subject', $subject->name_subject)->get('id');
            $user->subjects()->syncWithoutDetaching($subjectId);
            $user->subjects()->syncWithoutDetaching($subject_th_id);
        }


        return $this->handleResponse(null, null, 200);
    }

    public function remove_from_my_subjects(Request $request)
    {
        $user = auth('student')->user();
        $subjectId = $request->subject_id;

        $subject = student_has_subject::where('subject_id', $subjectId)->first();

        if (!$subject) {
            return $this->handleResponse(null, "there is no Subjects", 404);
        }
        $s = Subject::where('id', $subject->subject_id)->first();
        if ($s->subject_type == 'practical') {
            $subject_th = Subject::where('subject_type', 'theoretical')->where('name_subject', $s->name_subject)->first();
            $th = student_has_subject::where('student_id', $user->id)->where('subject_id', $subject_th->id)->first();
            if ($th) {
                $th->status_subject = '1';
                $th->save();
            }
            $user->subjects()->detach($subjectId);
        }
        if ($s->subject_type == 'theoretical') {
            $subject_pra_id = Subject::where('subject_type', 'practical')->where('name_subject', $s->name_subject)->get('id');

            $user->subjects()->detach($subjectId);
            $user->subjects()->detach($subject_pra_id);
        }


        return $this->handleResponse(null, "Subject deleted successfully", 200);
    }

    public function student_subjects()
    {

        $user = auth('student')->user();

        $subject_pra = $user->subjects()->where('subject_type', 'practical')->get();
        $subject_th = student_has_subject::where('student_id', $user->id)->where('status_subject', '1')->get();

        $data = collect(); // Create an empty collection to store the data

        if ($subject_pra) {
            $subject_pra->each(function ($subject) use ($data) { // Loop through practical subjects
                $subject_th = Subject::where('subject_type', 'theoretical')
                    ->where('name_subject', $subject->name_subject)
                    ->first();

                if ($subject_th) {
                    $data->push([
                        'id_pra' => $subject->id,
                        'id_theo' => $subject_th->id,
                        'name' => $subject->name_subject,
                        'type' => 'theoretical and practical',
                        'doctors_pra' => $subject->doctors()->pluck('full_name'),
                        'doctors_th' => $subject_th->doctors()->pluck('full_name'),
                        'teacher' => $subject->teacher()->pluck('full_name'),
                        'year' => $subject->year->name_year,
                    ]);
                }
            });
        }

        if ($subject_th) {
            $subject_th->each(function ($subject) use ($data) { // Loop through theoretical subjects
                $s = Subject::where('id', $subject->subject_id)->first();
                $data->push([
                    'id_theo' => $s->id,
                    'name' => $s->name_subject,
                    'type' => $s->subject_type,
                    'doctors' => $s->doctors()->pluck('full_name'),
                    'year' => $s->year->name_year,
                ]);
            });
        }

        return $this->handleResponse($data, '', 200);
    }


    //====================================================================================================

    public function add_to_my_files(Request $request)
    {

        $user = auth('student')->user();

        $fileId = $request->input('file_id');

        $file = File::where('id', $fileId)->get();

        if ($file->isEmpty()) {
            return $this->handleResponse(null, null, 404);
        }
        $data = $user->files()->syncWithoutDetaching($fileId);

        return $this->handleResponse(null, null, 200);
    }

    public function remove_from_my_files(Request $request)
    {
        $user = auth('student')->user();
        $fileId = $request->input('file_id');
        $files = Saved_Files::where('file_id', $fileId)->get();

        if ($files->isEmpty()) {
            return $this->handleResponse(null, "there is no file", 404);
        }
        $user->files()->detach($fileId);

        return $this->handleResponse(null, "file deleted successfully", 200);
    }

    public function student_files()
    {
        $user = auth('student')->user();


        if ($user) {
            $files = $user->files->map(function ($file) {
                return [
                    'id' => $file->id,
                    'name' => $file->file_name,
                    'type' => $file->file_type,
                    'file_path' => $file->file_path,
                    'subject' => $file->subject->name_subject,
                    'year' => $file->subject->year->name_year,
                ];
            });
            return $this->handleResponse($files, null, 200);
        }
        return $this->handleResponse(null, 'files not found', 404);
    }
}




 // $user = auth('student')->user();

        // $subject_pra = $user->subjects()->where('subject_type', 'practical')->get();


        // $subject_th = student_has_subject::where('student_id', $user->id)->where('status_subject', '1')->get();

        // if ($subject_pra)
        //     $data1 = $subject_pra->map(function ($subject) {
        //         $subject_th = Subject::where('subject_type', 'theoretical')->where('name_subject', $subject->name_subject)->first();

        //         return [
        //             'id_pra' => $subject->id,
        //             'id_theo' => $subject_th->id,
        //             'name' => $subject->name_subject,
        //             'type' => 'theoretical and practical',
        //             'doctors_pra' => $subject->doctors()->pluck('full_name'),
        //             'doctors_th' => $subject_th->doctors()->pluck('full_name'),
        //             'teacher' => $subject->teacher()->pluck('full_name'),
        //             'year' => $subject->year->name_year,
        //         ];
        //     });

        // if ($subject_th)
        //     $data2 = [$subject_th->map(function ($subject) {
        //         $s = Subject::where('id', $subject->subject_id)->first();
        //         return [
        //             'id_theo' => $s->id,
        //             'name' => $s->name_subject,
        //             'type' => $s->subject_type,
        //             'doctors' => $s->doctors()->pluck('full_name'),
        //             'year' => $s->year->name_year,
        //         ];
        //     })];
        // $data = $data1 + $data2;

        // return $this->handleResponse($data, '', 200);
