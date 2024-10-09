<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notification;
use App\Models\Subject;

use Illuminate\Support\Facades\Validator;

class SubjectController extends Controller
{
    public function get_notifications_subject($subject_id)
    {
        $subject = Subject::find($subject_id);
        if (!$subject) {
            return $this->handleResponse(null, 'subject not found', 404);
        }
        $notificationsdata = $subject->notifications;

        $notifications = $notificationsdata->map(
            function ($notification) {
                return [
                    'id' => $notification->id,
                    'title' => $notification->title,
                    'body' => $notification->body,
                    'date' => $notification->created_at->year . '/' . $notification->created_at->month . '/' . $notification->created_at->day,
                    'time' => $notification->created_at->hour . ':' . $notification->created_at->minute . ':' . $notification->created_at->second,

                ];
            }
        );

        return $this->handleResponse($notifications, 'notifications', 200);
    }


    public function delete_notifications_subject($notification_id)
    {
        $notification = Notification::find($notification_id);
        if (!$notification) {
            return $this->handleResponse(null, 'notification not found', 404);
        }
        $notification->delete();
        return $this->handleResponse(null, 'notification deleted', 200);
    }


    public function add_notifications_subject(Request $request)
    {
        $Validator = Validator::make($request->all(), [
            'subject_id' => 'required|exists:subjects,id',
            'body' => 'required',
        ]);

        if ($Validator->fails()) {
            return $this->handleError($Validator->errors());
        }

        $subject = Subject::find($request->subject_id);


        if (!$subject) {
            return $this->handleError('subject not found', '', 404);
        }
        $this->notifyStudents($request->subject_id,$request->body);
        return $this->handleResponse(null, '', 200);
    }
}
