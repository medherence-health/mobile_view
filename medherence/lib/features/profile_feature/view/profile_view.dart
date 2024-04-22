import 'package:flutter/material.dart';
import 'package:medherence/core/constants_utils/color_utils.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/features/auth_features/widget/validation_extension.dart';
import 'package:medherence/features/dashboard_feature/view/menu.dart';

import '../../../core/constants_utils/constants.dart';
import '../../../core/constants_utils/image_utils.dart';
import '../../auth_features/widget/textfield.dart';
import '../../dashboard_feature/view/dashboard.dart';
import '../widget/avatar_overlay_widget.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  late TextEditingController _nicknameController;
  Color nicknameFillColor = Colors.white70;
  int gender = 1;
  String selectedAvatar = ImageUtils.avatar4; // Default avatar

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nicknameController = TextEditingController();
  }

  void _selectAvatar(String avatar) {
    setState(() {
      selectedAvatar = avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins-bold.ttf",
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardView()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: AppColors.progressBarFill,
                      radius: 60,
                      child: Image.asset(
                        selectedAvatar,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: AvatarSelectionOverlay(
                                onAvatarSelected: _selectAvatar,
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Customize your avatar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.navBarColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 180.0,
                ),
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                  ),
                  children: [
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleAndTextFormField(
                            title: 'Nickname(Optional)',
                            formFieldHint: 'Type your nickname',
                            formFieldController: _nicknameController,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.text,
                            formFieldColor: nicknameFillColor,
                            formFieldValidator: (value) {
                              return value.nameValidation();
                            },
                          ),
                          SizedBox(height: 10),
                          const Text(
                            'First Name',
                            style: TextStyle(
                              fontSize: (18),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: (10)),
                          TextFormField(
                            initialValue: 'Demoj',
                            enabled:
                                false, // Disable editing directly in the field
                            readOnly: true,
                            decoration: InputDecoration(
                              // ... apply desired styling here
                              hintStyle: kFormTextDecoration.hintStyle,
                              filled: true,
                              fillColor: kFormTextDecoration.fillColor,
                              errorBorder: kFormTextDecoration.errorBorder,
                              border: kFormTextDecoration.border,
                              focusedBorder: kFormTextDecoration.focusedBorder,

                              hintText: "",
                            ),
                          ),
                          const SizedBox(height: (10)),
                          const Text(
                            'Last Name',
                            style: TextStyle(
                              fontSize: (18),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: (10)),
                          TextFormField(
                            initialValue: 'Adekunle',
                            enabled:
                                false, // Disable editing directly in the field
                            readOnly: true,
                            decoration: InputDecoration(
                              // ... apply desired styling here
                              hintStyle: kFormTextDecoration.hintStyle,
                              filled: true,

                              fillColor: kFormTextDecoration.fillColor,
                              errorBorder: kFormTextDecoration.errorBorder,
                              border: kFormTextDecoration.border,
                              focusedBorder: kFormTextDecoration.focusedBorder,

                              hintText: "",
                            ),
                          ),
                          const SizedBox(height: (10)),
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: (18),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: (10)),
                          TextFormField(
                            initialValue: '09123456789',
                            enabled:
                                false, // Disable editing directly in the field
                            readOnly: true,
                            decoration: InputDecoration(
                              // ... apply desired styling here
                              hintStyle: kFormTextDecoration.hintStyle,
                              filled: true,

                              fillColor: kFormTextDecoration.fillColor,
                              errorBorder: kFormTextDecoration.errorBorder,
                              border: kFormTextDecoration.border,
                              focusedBorder: kFormTextDecoration.focusedBorder,

                              hintText: "",
                            ),
                          ),
                          const SizedBox(height: (10)),
                          const Text(
                            'Age',
                            style: TextStyle(
                              fontSize: (18),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: (10)),
                          TextFormField(
                            initialValue: '30',
                            enabled:
                                false, // Disable editing directly in the field
                            readOnly: true,
                            decoration: InputDecoration(
                              // ... apply desired styling here
                              hintStyle: kFormTextDecoration.hintStyle,
                              filled: true,

                              fillColor: kFormTextDecoration.fillColor,
                              errorBorder: kFormTextDecoration.errorBorder,
                              border: kFormTextDecoration.border,
                              focusedBorder: kFormTextDecoration.focusedBorder,

                              hintText: "",
                            ),
                          ),
                          const SizedBox(height: (10)),
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: (18),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: (10)),
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: gender,
                                      onChanged: (val) => setState(() {
                                        gender = val! as int;
                                      }),
                                    ),
                                    Text('Male', style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                SizedBox(width: 15),
                                Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: gender,
                                      onChanged: (val) => setState(() {
                                        gender = val! as int;
                                      }),
                                    ),
                                    Text('Female',
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                SizedBox(width: 15),
                                Row(
                                  children: [
                                    Radio(
                                      value: 3,
                                      groupValue: gender,
                                      onChanged: (val) => setState(() {
                                        gender = val! as int;
                                      }),
                                    ),
                                    Text('Others',
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PrimaryButton(
                      buttonConfig: ButtonConfig(
                          action: () {}, text: 'Save', disabled: true),
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
