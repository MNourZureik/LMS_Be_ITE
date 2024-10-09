<?php

namespace App\Http\Controllers\Api;

use App\Traits\UploadFiles;
use App\Models\Teacher;
use App\Traits\UploadImageTrait;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use App\Models\File;


class TeachersController extends Controller
{
    use UploadImageTrait;
    use UploadFiles;

    public function LogOut()
    {
        auth('teacher')->logout();
        return $this->handleResponse(null, "teacher logged out successfully", 200);
    } //ok

    public function SetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [

            'password' => ['required', 'string', 'min:8'],
            'confirm_password' => ['required', 'string', 'min:8']
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        if ($request->password == $request->confirm_password) {
            $teacher = auth('teacher')->user();
            $teacher->password = $request->password;
            $teacher->save();
            return $this->handleResponse(null, "teacher set password successfully", 200);
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
            $email = auth('teacher')->user()->email;

            $dataAtemp = array(
                'email' => $email,
                'password' => $request->old_password,
            );
            try {
                $token = auth('teacher')->attempt($dataAtemp);
                if (!$token) {
                    return $this->handleResponse(null, "wrong  password", 400);
                }
                $teacher = auth('teacher')->user();
                $teacher->password = $request->new_password;
                $teacher->save();
            } catch (JWTException $e) {
                return $this->handleResponse(null, "Failed  please try again.", 500);
            }
            return $this->handleResponse(null, "teacher reset password successfully", 200);
        }
        return $this->handleResponse(null, "check that the new password maches the confirm password", 401);
    } //ok

    public function teacher_subjects()
    {
        $user = auth('teacher')->user();
        if ($user) {
            $data = $user->subjects->select('id', 'name_subject', 'subject_type', 'year_id')->where('subject_type', 'practical');
            return $this->handleResponse($data, null, 200);
        }
        return $this->handleResponse(null, 'teacher not found', 404);
    }

    public function Edit_teacher_photo(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'photo' => 'required|image|mimes:jpeg,png,jpg',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
            ], 400);
        }
        $userId = auth('teacher')->user()->id;
        if ($request->hasFile('photo')) {
            $path = $this->uploadimage($request, 'doctors');
            Teacher::where('id', $userId)->Update([
                'photo' => 'http://127.0.0.1:8000/' . $path,
            ]);
            return $this->handleResponse(null, 'photo Edited successfully', 200);
        }

        return $this->handleResponse(null, 'No photo uploaded', 400);
    }

    public function get_teacher_photo()
    {
        $userId = auth()->user()->id;
        $teacher_photo = Teacher::where('id', $userId)->first()->photo;
        return $this->handleResponse($teacher_photo, '', 200);
    }

    public function upload_file_teacher(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'file_name' => 'required|unique:files,file_name',
            'file_type' => 'required',
            'file' => 'required',
            'subject_id' => 'required|exists:subjects,id',

        ]);


        if ($validator->fails()) {
            return $this->handleResponse(null, 'file_name unique ', 403);
        }
        $teacher = auth('teacher')->user();

        if (!$teacher->subjects()->where('id', $request->subject_id)->exists()) {
            return $this->handleResponse(null, 'teacher does not have access to the specified subject', 400);
        }


        if ($request->hasFile('file')) {

            $request->file_type = strtoupper($request->file_type);
            $path = $this->upload_files($request, $request->file_type);

            File::create([
                'file_name' => $request->file_name,
                'file_path' =>  $path,
                'file_type' => $request->file_type,
                'doctor_id' => $teacher->id,
                'subject_id' => $request->subject_id,
            ]);

            $this->notifyStudents($request->subject_id, $request->file_type . ' ' . $request->file_name . " Uploaded");
            return $this->handleResponse(null, $request->file_type . ' uploaded successfully', 200);
        }

        return $this->handleResponse(null, 'NO' . $request->file_type . ' uploaded', 400);
    }
}
