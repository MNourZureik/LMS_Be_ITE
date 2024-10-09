<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

use App\Models\Teacher;
use App\Models\Doctor;
use App\Models\doctor_has_subject;
use App\Models\File;
use App\Models\Subject;
use App\Traits\UploadFiles;
use App\Traits\UploadImageTrait;
use Database\Seeders\Doctor_SubjectsSeeder;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;


class DoctorsController extends Controller
{
    use UploadImageTrait;
    use  UploadFiles;

    public function LogOut()
    {
        auth('doctor')->logout();
        return $this->handleResponse(null, "doctor logged out successfully", 200);
    } //ok ok

    public function SetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [

            'password' => ['required', 'string', 'min:8'],
            'confirm_password' => ['required', 'string', 'min:8']
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        if ($request->password == $request->confirm_password) {
            $doctor = auth('doctor')->user();
            $doctor->password = $request->password;
            $doctor->save();
            return $this->handleResponse(null, "doctor set password successfully", 200);
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
            $email = auth('doctor')->user()->email;

            $dataAtemp = array(
                'email' => $email,
                'password' => $request->old_password,
            );
            try {
                $token = auth('doctor')->attempt($dataAtemp);
                if (!$token) {
                    return $this->handleResponse(null, "wrong  password", 400);
                }
                $doctor = auth('doctor')->user();
                $doctor->password = $request->new_password;
                $doctor->save();
            } catch (JWTException $e) {
                return $this->handleResponse(null, "Failed  please try again.", 500);
            }
            return $this->handleResponse(null, "doctor reset password successfully", 200);
        }
        return $this->handleResponse(null, "check that the new password maches the confirm password", 401);
    } //ok



    public function doctor_subjects_theoretical()
    {
        $doctor = auth('doctor')->user();
        $subjects_doctor = $doctor->subjects;

        // Filter subjects first and then map them
        $data = $subjects_doctor->filter(function ($subject) {
            return $subject->subject_type == 'theoretical';
        })->map(function ($subject) {
            return [
                'id' => $subject->id,
                'name_subject' => $subject->name_subject,
                'subject_type' => $subject->subject_type,
                'year_id' => $subject->year_id,
            ];
        });

        return $this->handleResponse($data->values(), null, 200);
    }


    public function doctor_subjects_practical()
    {
        $doctor = auth('doctor')->user();
        $subjects_doctor = $doctor->subjects;

        // Filter subjects first and then map them
        $data = $subjects_doctor->filter(function ($subject) {
            return ($subject->subject_type == 'practical' || $subject->subject_type == 'project');
        })->map(function ($subject) {
            return [
                'id' => $subject->id,
                'name_subject' => $subject->name_subject,
                'subject_type' => $subject->subject_type,
                'year_id' => $subject->year_id,
            ];
        });

        return $this->handleResponse($data->values(), null, 200);
    }


    public function Edit_doctor_photo(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'photo' => 'required|image|mimes:jpeg,png,jpg',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
            ], 400);
        }
        $userId = auth('doctor')->user()->id;
        if ($request->hasFile('photo')) {
            $path = $this->uploadimage($request, 'doctors');
            Doctor::where('id', $userId)->Update([
                'photo' => 'http://127.0.0.1:8000/' . $path,
            ]);
            return $this->handleResponse(null, 'photo Edited successfully', 200);
        }

        return $this->handleResponse(null, 'No photo uploaded', 400);
    }

    public function get_doctor_photo()
    {
        $userId = auth()->user()->id;
        $teacher_photo = Doctor::where('id', $userId)->first()->photo;
        return $this->handleResponse($teacher_photo, '', 200);
    }

    public function upload_file_doctor(Request $request)
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
        $doctor = auth('doctor')->user();

        if (!$doctor->subjects()->where('subject_id', $request->subject_id)->exists()) {
            return $this->handleResponse(null, 'Doctor does not have access to the specified subject', 400);
        }


        if ($request->hasFile('file')) {

            $request->file_type = strtoupper($request->file_type);
            $path = $this->upload_files($request, $request->file_type);

            File::create([
                'file_name' => $request->file_name,
                'file_path' =>  $path,
                'file_type' => $request->file_type,
                'doctor_id' => $doctor->id,
                'subject_id' => $request->subject_id,
            ]);
            $this->notifyStudents($request->subject_id, $request->file_type . ' ' . $request->file_name . " Uploaded");
            return $this->handleResponse(null, $request->file_type . ' uploaded successfully', 200);
        }

        return $this->handleResponse(null, 'NO' . $request->file_type . ' uploaded', 400);
    }


    public function delete_file($file_id)
    {
        $file = File::find($file_id);

        if (!$file) {
            return $this->handleResponse(null, 'file not found', 400);
        }
        $subject = $file->subject;
        $this->notifyStudents($subject->id, $file->file_type . ' ' . $file->file_name . ' deleted');
        $file->delete();
        return $this->handleResponse(null, 'file deleted successfully', 200);
    }
}
