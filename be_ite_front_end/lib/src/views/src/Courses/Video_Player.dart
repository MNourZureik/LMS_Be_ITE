import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Courses_Controllers/video_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlay extends StatelessWidget {
  const VideoPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<VideoController>(
          init: VideoController(),
          builder: (controller) {
            // بناء مشغل يوتيوب باستخدام YoutubePlayerBuilder
            return YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller:
                    controller.youtubePlayerController, // تعيين المتحكم بالمشغل
                showVideoProgressIndicator: true, // إظهار مؤشر تقدم الفيديو
                progressIndicatorColor: Colors.red, // تعيين لون مؤشر التقدم
              ),
              builder: (context, player) {
                // بناء عمود يحتوي على المشغل
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    player, // تضمين مشغل الفيديو
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
