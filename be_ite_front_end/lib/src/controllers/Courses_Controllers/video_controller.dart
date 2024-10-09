import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// تعريف VideoController لإدارة حالة مشغل يوتيوب
class VideoController extends GetxController {
  late YoutubePlayerController youtubePlayerController;

  @override
  void onInit() {
    // تهيئة المتحكم بمشغل يوتيوب عند إنشاء VideoController
    super.onInit();
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: 'ilmZwseiO-k', // معرف الفيديو الأولي
      flags: const YoutubePlayerFlags(
        autoPlay: true, // تشغيل الفيديو تلقائيًا
        mute: false, // عدم كتم الصوت
      ),
    );
  }

  @override
  void onClose() {
    // التخلص من المتحكم بمشغل يوتيوب عند إغلاق VideoController
    youtubePlayerController.dispose();
    super.onClose();
  }
}
