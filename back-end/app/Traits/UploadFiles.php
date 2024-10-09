<?php

namespace App\Traits;


use Illuminate\Http\Request;

trait UploadFiles
{

    public function upload_files(Request $request, $foldername)
    {
        $file = $request->file('file')->getClientOriginalName();
        $path = $request->file('file')->storeAs($foldername, $file, 'up_files');

        return 'files/' . $path;
    }
}
