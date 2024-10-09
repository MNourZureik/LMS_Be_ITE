<?php

namespace App\Traits;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

use Illuminate\Http\File;
use Illuminate\Support\Str;

trait UploadImageTrait
{
    public function uploadimage(Request $request, $foldername)
    {

        $img = $request->file('photo')->getClientOriginalName();

        $path = $request->file('photo')->storeAs($foldername, $img, 'up_photo');

        return 'images/' . $path;
    }

    public function uploadimageFromBytes($data, $imageName)
    {
        $imageData = $data["image"];

        $imageData = base64_decode($imageData);

        $path = public_path("images\courses\\" . $imageName);

        file_put_contents($path, $imageData);

        return 'images\courses\\' . $imageName;
    }
}
