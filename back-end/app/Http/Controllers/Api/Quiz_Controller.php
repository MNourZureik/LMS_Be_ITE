<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\{
    Answer, Question, Quiz, Student_has_Answer, Student_has_Quiz,
    Subject,
};
use Illuminate\Support\Facades\Validator;

class Quiz_Controller extends Controller
{
    public function add_quiz(Request $request)
    {
        $data = $this->getRequestData($request);

        $validator = $this->validateQuizData($data);
        if ($validator->fails()) {
            return $this->handleResponse(null, $validator->errors()->first(), 400);
        }

        $quiz = $this->createQuiz($data);
        $this->createQuestionsAndAnswers($data['questions'], $quiz->id);
        $this->notifyStudents($data['subject_id'], "Quiz Uploaded");

        return $this->handleResponse(null, "Quiz added successfully", 200);
    }

    private function getRequestData(Request $request): array
    {
        return json_decode($request->getContent(), true);
    }

    private function validateQuizData(array $data)
    {
        return Validator::make($data, [
            'subject_id' => 'required|integer',
            'type' => 'required|string',
            'questions' => 'required|array',
            'questions.*.question' => 'required|string',
            'questions.*.answers' => 'required|array',
            'questions.*.answers.*' => 'required|string',
            'questions.*.correctAnswer' => 'required|integer',
            'level' => 'required|string',
            'time' => 'required|string',
            'num_of_questions' => 'required|integer',
        ]);
    }

    private function createQuiz(array $data): Quiz
    {
        return Quiz::create([
            'doctor_id' => optional(auth('doctor')->user())->id,
            'teacher_id' => optional(auth('teacher')->user())->id,
            'subject_id' => $data['subject_id'],
            'type' => $data['type'],
            'time' => $data['time'],
            'level' => $data['level'],
            'num_question' => $data['num_of_questions'],
        ]);
    }

    private function createQuestionsAndAnswers(array $questions, int $quizId)
    {
        foreach ($questions as $questionData) {
            $question = Question::create([
                'question' => $questionData['question'],
                'quiz_id' => $quizId,
            ]);

            $this->createAnswers($questionData['answers'], $questionData['correctAnswer'], $question->id);
        }
    }

    private function createAnswers(array $answers, int $correctAnswerIndex, int $questionId)
    {
        foreach ($answers as $index => $answer) {
            Answer::create([
                'answer' => $answer,
                'correct_answer' => $index === $correctAnswerIndex,
                'question_id' => $questionId,
            ]);
        }
    }


    public function delete_quiz($id)
    {
        $quiz = Quiz::find($id);

        if (!$quiz) {
            return $this->handleResponse(null, "Quiz not found", 404);
        }

        $this->notifyStudents($quiz->subject_id, "Quiz Deleted");
        $quiz->delete();

        return $this->handleResponse(null, "Quiz deleted successfully", 200);
    }
    public function get_quiz_info($id)
    {

        $quiz = Quiz::with(['questions' => function ($query) {
            $query->with('answers');
        }])->find($id);


        $questions = $quiz->questions->map(function ($question) {
            return [
                'qeustion' => $question->question,
                'answers' =>  $question->answers->pluck('answer'),
                'correct_answer' => $question->answers()->where('correct_answer', 1)->pluck('answer')->first(),
            ];
        });

        $is_student = auth('student')->user();
        $is_solved = null;
        $student_answers = null;
        $var = null;
        if ($is_student) {
            $is_quiz_solved = Student_has_Quiz::where('quiz_id', $id)->first();
            if ($is_quiz_solved) {
                $is_solved = 1;

                for ($i = 0; $i < count($quiz->questions); $i++) {
                    $student_answer_id  = $quiz->questions[$i]->student_answer()->pluck('answer_id')->first();
                    if ($student_answers) {

                        $student_answers[]  = Answer::findOrFail($student_answer_id)->answer;
                    } else {
                        $student_answers = [Answer::findOrFail($student_answer_id)->answer];
                    }
                }
            } else {
                $is_solved = 0;
            }
        }
        if ($is_student) {
            return $data = [
                'student_answers' => $student_answers,
                'is_solved' => $is_solved,
                'id' => $quiz->id,
                'subject' => Subject::where('id', $quiz->subject_id)->first()->name_subject,
                'type' => $quiz->type,
                'time' => $quiz->time,
                'level' => $quiz->level,
                'num_question' => $quiz->num_question,
                'questions' => $questions,
            ];
        } else {
            return $data = [
                'id' => $quiz->id,
                'subject' => Subject::where('id', $quiz->subject_id)->first()->name_subject,
                'type' => $quiz->type,
                'time' => $quiz->time,
                'level' => $quiz->level,
                'num_question' => $quiz->num_question,
                'questions' => $questions,
            ];
        }
    }



    public function show_quizzes()
    {
        $user = auth()->user();
        $quizzes = $user->quizzes->map(function ($quiz) {
            return $this->get_quiz_info($quiz->id);
        });

        return $this->handleResponse($quizzes, 'Quizzes list', 200);
    }

    public function get_quizzes_for_student_subjects()
    {
        $student = auth('student')->user();

        $student_subjects_ids = $student->subjects->pluck('id');
        if (!$student_subjects_ids)
            return $this->handleResponse(null, 'no subject found', 404);

        $quizzes_ids = Quiz::whereIn('subject_id', $student_subjects_ids)->pluck('id');
        if (!$quizzes_ids)
            return $this->handleResponse(null, 'no quizzes found', 404);



        $data = [];
        for ($i = 0; $i < count($quizzes_ids); $i++) {
            if ($data) {
                $data[] = $this->get_quiz_info($quizzes_ids[$i]);
            } else {
                $data = [$this->get_quiz_info($quizzes_ids[$i])];
            }
        }
        return $this->handleResponse($data, 'finals', 200);
    }

    public function quizzes_solved_by_student(Request $request)
    {
        $request1 = json_decode($request->getContent(), true);


        $student = auth('student')->user();
        $quiz_id = $request1["quiz_id"];
        $student_answers = $request1["answers"];
        $quiz = Quiz::find($quiz_id);

        if (!$quiz)
            return $this->handleResponse(null, 'no quizzes found', 404);
        else {
            Student_has_Quiz::create([
                'quiz_id' => $quiz->id,
                'student_id' => $student->id,

            ]);
        }



        for ($i = 0; $i < count($quiz->questions); $i++) {
            $answer_id   = $quiz->questions[$i]->answers()->where('answer', $student_answers[$i])->first()->id;
            Student_has_Answer::create([
                'answer_id' =>  $answer_id,
                'student_id' => $student->id,
                'question_id' => $quiz->questions[$i]->id

            ]);
        }




        return $this->handleResponse(null, 'Solved successfully', 200);
    }
}
