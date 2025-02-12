import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/core/utils/color_utils.dart';
import 'package:medherence/features/auth/widget/validation_extension.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/size_manager.dart';
import '../../auth/widget/textfield.dart';
import '../view_model/profile_view_model.dart';
import '../widget/avatar_overlay_widget.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  late Future<UserData?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfileData();
  }

  Future<UserData?> _fetchProfileData() async {
    final profileModel = Provider.of<ProfileViewModel>(context, listen: false);
    var userData = await profileModel.getUserData(); // Simulating data fetch
    return userData;
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: FutureBuilder<UserData?>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while fetching profile data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error case
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // Handle no data case
            return const Center(child: Text('Failed to load profile.'));
          }

          final profileModel = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: AppColors.progressBarFill,
                        radius: 60,
                        child: Image.asset(
                          context.watch<ProfileViewModel>().selectedAvatar,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: AvatarSelectionOverlay(
                                  onAvatarSelected: (avatar) {
                                    context
                                        .watch<ProfileViewModel>()
                                        .setAvatar(avatar);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Customize your avatar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navBarColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                _buildForm(profileModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(UserData userData) {
    var model = context.watch<ProfileViewModel>();
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: ListView(
        padding: const EdgeInsets.only(top: 30, bottom: 20),
        children: [
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndTextFormField(
                  title: 'Nickname(Optional)',
                  formFieldHint: 'Type your nickname',
                  formFieldController: model.nicknameController,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                  formFieldColor: model.nicknameFillColor,
                  formFieldValidator: (value) => value.nameValidation(),
                  onChanged: (value) {
                    setState(() {
                      model.nicknameFillColor = value.isNotEmpty
                          ? kFormTextDecoration.fillColor!
                          : Colors.white70;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildReadOnlyField('First Name', userData.firstName ?? ""),
                _buildReadOnlyField('Last Name', userData.lastName ?? ""),
                _buildReadOnlyField('Phone Number', userData.phoneNumber ?? ""),
                _buildReadOnlyField('Age', ""),
                _buildGenderSelection(model),
                const SizedBox(height: 10),
                const Text('Next of Kin information',
                    style: TextStyle(fontSize: 16, color: AppColors.darkGrey)),
                const SizedBox(height: 15),
                _buildEditableField('First Name', 'Type your NOK\'s first name',
                    model.nokFirstNameController, model.nokFirstFillColor),
                _buildEditableField('Last Name', 'Type your NOK\'s last name',
                    model.nokLastNameController, model.nokLastFillColor),
                _buildEditableField('Phone Number', 'Type your NOK\'s number',
                    model.nokPhoneNumberController, model.nokPhoneFillColor,
                    isNumber: true),
                _buildEditableField('Relationship', 'e.g Mother',
                    model.nokRelationController, model.nokRelationFillColor),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 50),
          PrimaryButton(
            textSize: SizeMg.text(25),
            buttonConfig: ButtonConfig(
              action: () {
                model.setNickName(model.nicknameController.text.trim());
                model.saveProfile(context);
                Navigator.pop(context);
              },
              text: 'Save Changes',
              disabled: false,
            ),
            width: double.infinity,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, color: AppColors.black)),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: value,
          enabled: false,
          readOnly: true,
          decoration: kFormTextDecoration.copyWith(hintText: ""),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableField(String title, String hint,
      TextEditingController controller, Color? fillColor,
      {bool isNumber = false}) {
    return TitleAndTextFormField(
      title: title,
      formFieldHint: hint,
      formFieldController: controller,
      textInputAction: TextInputAction.next,
      textInputType: isNumber ? TextInputType.number : TextInputType.text,
      formFieldColor: fillColor,
      formFieldValidator: (value) => value.nameValidation(),
      onChanged: (value) {
        setState(() {
          fillColor = value.isNotEmpty
              ? kFormTextDecoration.fillColor!
              : Colors.white70;
        });
      },
    );
  }

  Widget _buildGenderSelection(ProfileViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender',
            style: TextStyle(fontSize: 18, color: AppColors.black)),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              _buildGenderRadio(model, 1, 'Male'),
              const SizedBox(width: 15),
              _buildGenderRadio(model, 2, 'Female'),
              const SizedBox(width: 15),
              _buildGenderRadio(model, 3, 'Others'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRadio(ProfileViewModel model, int value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: model.gender,
          onChanged: model.setGender,
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
