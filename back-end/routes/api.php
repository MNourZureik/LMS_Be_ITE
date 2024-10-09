<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\Api\DoctorsController;
use App\Http\Controllers\Api\StudentsController;
use App\Http\Controllers\Api\TeachersController;
use App\Http\Controllers\Api\YearController;
use App\Http\Controllers\Wep\AdminsController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\Quiz_Controller;
use App\Http\Controllers\SubjectController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


//?section Auth
//login admin......standard email and password
Route::post('login-admin', [AdminsController::class, 'login']);


//login by email for doctor or teacher or student ...... checking is found in database
Route::post('log_in_by_email', [AuthController::class, 'LogInByEmail']);


//forget password for doctor or teacher or student
Route::post('forget-password', [AuthController::class, 'ForgetPassword']);


//login doctor by verificationcode or password
Route::post('log_in_doctor_by_code', [AuthController::class, 'LogInDoctorByCode']);
Route::post('log_in_doctor_by_password', [AuthController::class, 'LogInDoctorByPassword']);


//login teacher by verificationcode or password
Route::post('log_in_teacher_by_code', [AuthController::class, 'LogInTeacherByCode']);
Route::post('log_in_teacher_by_password', [AuthController::class, 'LogInTeacherByPassword']);


//login student by verificationcode or password
Route::post('log_in_student_by_code', [AuthController::class, 'LogInStudentByCode']);
Route::post('log_in_student_by_password', [AuthController::class, 'LogInStudentByPassword']);











Route::middleware('auth:admin')->group(function () {
    //? admin section :
    Route::get('/logout-admin', [AdminsController::class, 'logout']);
    Route::post('reset-password-admin', [AdminsController::class, 'resetpassword']);
    Route::post('/register-student', [AdminsController::class, 'registerstudent']);
    Route::post('/delete-student', [AdminsController::class, 'delete_student']);
    //? teacher section :
    Route::post('/register_teacher', [AdminsController::class, 'registerteacher']);
    Route::post('/cancel-teacher-for-subject', [AdminsController::class, 'cancel_teacher_for_subject']);
    Route::post('/appointment-teacher', [AdminsController::class, 'appointment_teacher']);

    //? doctor section :
    Route::post('/register_doctor', [AdminsController::class, 'registerdoctor']);
    Route::post('/cancel-doctor-for-subject', [AdminsController::class, 'cancel_doctor_for_subject']);
    Route::post('/appointment-doctor', [AdminsController::class, 'appointment_doctor']);

    //? course section :
    Route::post('/add-course', [AdminsController::class, 'add_course']);
    Route::post('/delete-course', [AdminsController::class, 'delete_course']);

    //? subject section :
    Route::get('/subjects-theoretical', [AdminsController::class, 'subjects_theoretical']);
    Route::get('/subjects-practical', [AdminsController::class, 'subjects_practical']);
});


Route::middleware('auth:doctor')->group(function () {

    Route::post('/upload_file_doctor', [DoctorsController::class, 'upload_file_doctor']);
    Route::get('/get-doctor-photo', [DoctorsController::class, 'get_doctor_photo']);
    Route::post('/Edit-doctor-photo', [DoctorsController::class, 'Edit_doctor_photo']);
    Route::get('/doctor-subjects-theoretical', [DoctorsController::class, 'doctor_subjects_theoretical']);
    Route::get('/doctor-subjects-practical', [DoctorsController::class, 'doctor_subjects_practical']);
    Route::post('set-password-doctor', [DoctorsController::class, 'SetPassword']);
    Route::post('reset-password-doctor', [DoctorsController::class, 'ResetPassword']);
    Route::get('/logout-doctor', [DoctorsController::class, 'LogOut']);
});

Route::middleware('auth:teacher')->group(function () {
    Route::post('/upload_file_teacher', [TeachersController::class, 'upload_file_teacher']);
    Route::get('/get-teacher-photo', [TeachersController::class, 'get_teacher_photo']);
    Route::post('/Edit-teacher-photo', [TeachersController::class, 'Edit_teacher_photo']);
    Route::get('/teacher-subjects', [TeachersController::class, 'teacher_subjects']);
    Route::post('set-password-teacher', [TeachersController::class, 'SetPassword']);
    Route::post('reset-password-teacher', [TeachersController::class, 'ResetPassword']);
    Route::get('/logout-teacher', [TeachersController::class, 'LogOut']);
});

Route::middleware('auth:student')->group(function () {
    Route::post('/register-fcm-token', [StudentsController::class, 'register_fcm_token']);
    Route::post('quizzes-solved-by-student', [Quiz_Controller::class, 'quizzes_solved_by_student']);
    Route::get('get-quizzes-for-student-subjects', [Quiz_Controller::class, 'get_quizzes_for_student_subjects']);
    Route::get('/student-files', [StudentsController::class, 'student_files']);
    Route::post('/remove-from-my-files', [StudentsController::class, 'remove_from_my_files']);
    Route::post('/add-to-my-files', [StudentsController::class, 'add_to_my_files']);
    Route::get('/student-subjects-theoretical', [StudentsController::class, 'student_subjects_theoretical']);
    Route::post('/add-to-my-subjects', [StudentsController::class, 'add_to_my_subjects']);
    Route::post('/remove-from-my-subjects', [StudentsController::class, 'remove_from_my_subjects']);
    Route::get('/get-student-photo', [StudentsController::class, 'get_student_photo']);
    Route::post('/Edit-student-photo', [StudentsController::class, 'Edit_student_photo']);
    Route::get('/year-subjects-theoretical/{id}', [YearController::class, 'year_subjects_theoretical']);
    Route::get('/year-subjects-practical/{id}', [YearController::class, 'year_subjects_practical']);
    Route::post('set-password-student', [StudentsController::class, 'SetPassword']);
    Route::post('reset-password-student', [StudentsController::class, 'ResetPassword']);
    Route::get('/logout-student', [StudentsController::class, 'LogOut']);
    Route::get('/student-subjects', [StudentsController::class, 'student_subjects']);
    Route::get('/student-subjects-practical', [StudentsController::class, 'student_subjects_practical']);
    Route::get('/show-courses', [AdminsController::class, 'show_courses']);
});






Route::middleware('auth:doctor,student,teacher')->group(function () {
    Route::post('/get-files-names', [YearController::class, 'get_files_names']);
    Route::get('/get-notifications-subject/{id}', [SubjectController::class, 'get_notifications_subject']);
});







Route::middleware('auth:doctor,teacher')->group(function () {
    Route::post('/add-notifications-subject', [SubjectController::class, 'add_notifications_subject']);
    Route::get('/delete_file/{id}', [DoctorsController::class, 'delete_file']);
    Route::get('/delete-notifications-subject/{id}', [SubjectController::class, 'delete_notifications_subject']);
    Route::post('add-quiz', [Quiz_Controller::class, 'add_quiz']);
    Route::get('show-quizzes', [Quiz_Controller::class, 'show_quizzes']);
    Route::get('delete-quiz/{id}', [Quiz_Controller::class, 'delete_quiz']);
});
