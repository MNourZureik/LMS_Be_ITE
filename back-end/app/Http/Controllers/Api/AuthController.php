<?php

namespace App\Http\Controllers\API;


use App\Http\Controllers\Controller;
use App\Mail\SendCode;
use App\Models\Doctor;

use App\Models\Student;

use App\Models\Teacher;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;


use Illuminate\Support\Facades\Validator;
use PHPOpenSourceSaver\JWTAuth\Exceptions\JWTException;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth;


class AuthController extends Controller
{
    //login for teacher and doctor and student by email and (password or code)
    public
    function LogInByEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required', 'email']
        ]);
        //if $validator fails
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        //search about email in doctor's table
        $doctor_email = Doctor::where('email', $request->email)->first();
        //if email exist in doctor's table
        if ($doctor_email) {
            //if email exist in doctor's table and nonactive
            if (!$doctor_email->email_verify) {
                $verificationCode = $this->SendCode($doctor_email);
                $doctor_email->verificationCode = $verificationCode;
                $doctor_email->save();
                return $this->handleResponse(null, 'non_active_doctor', 201);

                //if email exist in doctor's table and active
            } elseif ($doctor_email->email_verify) {
                return $this->handleResponse(null, 'active_doctor', 200);
            }
        }

        //search about email in teacher's table
        $teacher_email = Teacher::where('email', $request->email)->first();
        //if email exist in teacher's table
        if ($teacher_email) {
            //if email exist in teacher's table and nonactive
            if (!$teacher_email->email_verify) {
                $verificationCode = $this->SendCode($teacher_email->email);
                $teacher_email->verificationCode = $verificationCode;
                $teacher_email->save();
                return $this->handleResponse(null, 'non_active_teacher', 201);
                //if email exist in teacher's table and active
            } elseif ($teacher_email->email_verify) {
                return $this->handleResponse(null, 'active_teacher', 200);
            }
        }

        //search about email in student's table
        $student_email = Student::where('email', $request->email)->first();
        //if email exist in student's table$user->profile
        if ($student_email) {
            //if email exist in teacher's table and nonactive
            if (!$student_email->email_verify) {
                $verificationCode = $this->SendCode($student_email->email);
                $student_email->verificationCode = $verificationCode;
                $student_email->save();
                return $this->handleResponse(null, 'non_active_student', 201);
                //if email exist in teacher's table and active
            } elseif ($student_email->email_verify) {

                return $this->handleResponse(null, 'active_student', 200);
            }
        }
        return $this->handleResponse(null, 'this email is not exist', 404);
    } //ok//ok//ok

    public
    function ForgetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required', 'email']
        ]);
        //if $validator fails
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        //search about email in doctor's table
        $doctor_email = Doctor::where('email', $request->email)->first();
        //if email exist in doctor's table
        if ($doctor_email) {
            $verificationCode = $this->SendCode($doctor_email->email);
            $doctor_email->verificationCode = $verificationCode;
            $doctor_email->save();
            return $this->handleResponse(null, 'the verification Code is sent to doctor', 200);
        }

        //search about email in teacher's table
        $teacher_email = Teacher::where('email', $request->email)->first();
        //if email exist in teacher's table
        if ($teacher_email) {
            $verificationCode = $this->SendCode($teacher_email->email);
            $teacher_email->verificationCode = $verificationCode;
            $teacher_email->save();
            return $this->handleResponse(null, 'the verification Code is sent to teacher', 200);
        }

        //search about email in student's table
        $student_email = Student::where('email', $request->email)->first();
        //if email exist in student's table
        if ($student_email) {
            $verificationCode = $this->SendCode($student_email->email);
            $student_email->verificationCode = $verificationCode;
            $student_email->save();
            return $this->handleResponse(null, 'the verification Code is sent to student', 200);
        }
        return $this->handleResponse(null, 'this email is not exist', 404);
    }


    public
    function generateVerificationCode(): int
    {
        $verificationCode = random_int(100000, 999999); // توليد رقم عشوائي بين 100000 و 999999
        return $verificationCode;
    } //ok

    public
    function SendCode($email)
    {

        $verificationCode = strval($this->generateVerificationCode());
        Mail::to($email)->send(new SendCode($verificationCode));
        return $verificationCode;
    } //ok


    public
    function LogInTeacherByCode(Request $request)
    {


        $validator = Validator::make($request->all(), [
            'email' => ['required'],
            'verificationCode' => ['required']
        ]);
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        try {


            $teacher = Teacher::where('email', $request->email)->where('verificationCode', $request->verificationCode)->first();
            $token = null;
            if ($teacher)
                $token = JWTAuth::fromUser($teacher);

            if (!$token) {
                return $this->handleResponse(null, "wrong  verificationCode", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $teacher->email_verify = 1;
        $teacher->save();
        $data = [];
        $data['teacher'] = $teacher;
        $data['token'] = $token;
        $teacher->verificationCode = null;
        $teacher->save();
        return $this->handleResponse($data, "doctor logged in successfully", 200);
    } //ok

    public
    function LogInTeacherByPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [

            'email' => ['required', 'email'],
            'password' => ['required', 'string', 'min:8']

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        try {
            $token = auth('teacher')->attempt($request->only(['email', 'password']));
            if (!$token) {
                return $this->handleResponse(null, "wrong  password", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $teacher = auth('teacher')->user();
        $data = [];
        $data['teacher'] = $teacher;
        $data['token'] = $token;
        return $this->handleResponse($data, "teacher logged in successfully", 200);
    } //ok


    public
    function LogInDoctorByPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [

            'email' => ['required', 'email'],
            'password' => ['required', 'string', 'min:8']

        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        try {
            $token = auth('doctor')->attempt($request->only(['email', 'password']));
            if (!$token) {
                return $this->handleResponse(null, "wrong  password", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $doctor = auth('doctor')->user();
        $data = [];
        $data['doctor'] = $doctor;
        $data['token'] = $token;
        return $this->handleResponse($data, "doctor logged in successfully", 200);
    } //ok


    public
    function LogInDoctorByCode(Request $request)
    {


        $validator = Validator::make($request->all(), [
            'email' => ['required'],
            'verificationCode' => ['required']
        ]);
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        try {


            $doctor = Doctor::where('email', $request->email)->where('verificationCode', $request->verificationCode)->first();
            $token = null;
            if ($doctor)
                $token = JWTAuth::fromUser($doctor);

            if (!$token) {
                return $this->handleResponse(null, "wrong  verificationCode", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $doctor->email_verify = 1;
        $doctor->save();
        $data = [];
        $data['doctor'] = $doctor;
        $data['token'] = $token;
        $doctor->verificationCode = null;
        $doctor->save();
        return $this->handleResponse($data, "doctor logged in successfully", 200);
    } //ok

    public
    function LogInStudentByPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'password' => ['required', 'string', 'min:8'],
            'email' => ['required', 'email']
        ]);


        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);


        try {
            $token = auth('student')->attempt($request->only(['email', 'password']));
            if (!$token) {
                return $this->handleResponse(null, "wrong  password", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $student = auth('student')->user();
        $data = [];
        $data['student'] = $student;
        $data['token'] = $token;
        return $this->handleResponse($data, "student logged in successfully", 200);
    } //ok

    public
    function LogInStudentByCode(Request $request)
    {


        $validator = Validator::make($request->all(), [
            'email' => ['required'],
            'verificationCode' => ['required']
        ]);
        if ($validator->fails())
            return $this->handleResponse(null, $validator->errors()->first(), 400);

        try {


            $student = Student::where('email', $request->email)->where('verificationCode', $request->verificationCode)->first();
            $token = null;
            if ($student)
                $token = JWTAuth::fromUser($student);

            if (!$token) {
                return $this->handleResponse(null, "wrong  verificationCode", 201);
            }
        } catch (JWTException $e) {
            return $this->handleResponse(null, "Failed to login, please try again.", 500);
        }
        $student->email_verify = 1;
        $student->save();
        $data = [];
        $data['student'] = $student;
        $data['token'] = $token;
        $student->verificationCode = null;
        $student->save();
        return $this->handleResponse($data, "doctor logged in successfully", 200);
    } //ok
}
