<?php

namespace App\Traits;

use App\Models\link;
use Illuminate\Support\Facades\Validator;

trait ValidationTrait
{
    public function validateCourseData($data)
    {
        $validator = Validator::make($data, [
            'course_name' => 'required|string|unique:courses,course_name',
            'auther_name' => 'required|string',
            'discreption' => 'required|string',
            'image' => 'required|string',
            'image_name' => 'required|string',
            'links' => 'required|array',
            'links.*.video_url' => 'required', //'required|url',
            'links.*.video_title' => 'required|string',
            'links.*.video_time' => 'required|string',
        ]);

        return $validator;
    }

    public function createLink($courseId, $linkData)
    {
        Link::create([
            'course_id' => $courseId,
            'video_url' => $linkData['video_url'],
            'video_title' => $linkData['video_title'],
            'video_time' => $linkData['video_time'],
        ]);
    }
}
