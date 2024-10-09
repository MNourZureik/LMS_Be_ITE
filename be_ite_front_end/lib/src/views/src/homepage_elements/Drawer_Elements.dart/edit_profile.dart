import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';

import '../../../../../main.dart';
import '../../../../controllers/Home_Page_Controllers/Drawer_Controller.dart';
import '../../../../models/Themes.dart';
import '../../../../widgets/ElevatedButton.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    DrawersController drController = Get.put(DrawersController());
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          appData!.setString('user_photo_localy', '');
          return true;
        },
        child: Scaffold(
          backgroundColor: is_Dark!.getString('is_dark') == 'true'
              ? Themes.darkColorScheme.background
              : Colors.white,
          appBar: AppBar(
            backgroundColor: is_Dark!.getString('is_dark') == 'true'
                ? Themes.darkColorScheme.background
                : Themes.colorScheme.primaryContainer,
            elevation: 3,
            title: Text(
              'Edit Profile :',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              is_Dark!.getString('is_dark') == 'true'
                                  ? Colors.white
                                  : Colors.blue,
                          radius: Themes.getWidth(context) / 4,
                          child: GetBuilder<DrawersController>(
                            id: 'image',
                            init: DrawersController(),
                            builder: (drController) {
                              return appData!.getString('user_photo') != '' &&
                                      appData!.getString('user_photo_localy') ==
                                          ''
                                  ?
                                  // user photo from backend :
                                  CircleAvatar(
                                      radius: Themes.getWidth(context) / 4.1,
                                      backgroundImage: FileImage(
                                        File(
                                          appData!.getString('user_photo')!,
                                        ),
                                      ),
                                    )
                                  : appData!.getString('user_photo_localy') !=
                                          ''
                                      // picked image from storage :
                                      ? CircleAvatar(
                                          radius:
                                              Themes.getWidth(context) / 4.1,
                                          backgroundImage: FileImage(
                                            File(
                                              appData!.getString(
                                                  'user_photo_localy')!,
                                            ),
                                          ),
                                        )
                                      // default photo :
                                      : Auth!.getString("user") ==
                                              "active_student"
                                          ? CircleAvatar(
                                              radius: Themes.getWidth(context) /
                                                  4.1,
                                              backgroundImage: const AssetImage(
                                                'assets/images/student.png',
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: Themes.getWidth(context) /
                                                  4.1,
                                              backgroundImage: const AssetImage(
                                                'assets/images/teacher.png',
                                              ),
                                            );
                            },
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 130,
                          child: CircleAvatar(
                            backgroundColor:
                                is_Dark!.getString('is_dark') == 'true'
                                    ? Colors.white
                                    : Colors.blue,
                            radius: Themes.getWidth(context) / 15,
                            child: Container(
                              width: Themes.getWidth(context) / 8,
                              height: Themes.getWidth(context) / 8,
                              decoration: BoxDecoration(
                                color: is_Dark!.getString('is_dark') == 'true'
                                    ? Themes.darkColorScheme.background
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  drController.PickImageFromSource(context);
                                },
                                child: Icon(
                                  Iconsax.edit,
                                  color: is_Dark!.getString('is_dark') != 'true'
                                      ? Colors.blue
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    //user name text field :
                    Form(
                      key: drController.Form_key,
                      child: MyTextFormField(
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "user name missing";
                          }
                          if (value.trim().length < 3) {
                            return "user name too short";
                          }
                          if (int.tryParse(value) != null) {
                            return 'invalid username';
                          }
                        },
                        save: (value) {
                          if (value != Auth!.getString('user_name')) {
                            Auth!.setString('user_name', value!);
                          }
                        },
                        keyboard: TextInputType.text,
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: 'User name',
                        initValue: Auth!.getString('user_name'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GetBuilder<DrawersController>(
                              id: 'circle_image',
                              init: DrawersController(),
                              builder: (context) {
                                return MyElevetedButton(
                                  onTap: () => drController.SavePhoto(),
                                  width: 8.5,
                                  height: 20,
                                  BackColor: is_Dark!.getString('is_dark') ==
                                          'true'
                                      ? Themes
                                          .darkColorScheme.onPrimaryContainer
                                      : Themes.colorScheme.onSecondaryContainer,
                                  widget: drController.circleImage ??
                                      Text(
                                        'Save',
                                        style:
                                            Get.textTheme.titleMedium!.copyWith(
                                          color:
                                              is_Dark!.getString('is_dark') ==
                                                      'true'
                                                  ? Colors.black
                                                  : Colors.white,
                                        ),
                                      ),
                                );
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyElevetedButton(
                            onTap: () {
                              appData!.setString('user_photo_localy', '');
                              Get.back();
                            },
                            width: 10,
                            height: 20,
                            BackColor: is_Dark!.getString('is_dark') == 'true'
                                ? Themes.darkColorScheme.onPrimaryContainer
                                : Themes.colorScheme.onSecondaryContainer,
                            widget: Text(
                              'Cancel',
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: is_Dark!.getString('is_dark') == 'true'
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
