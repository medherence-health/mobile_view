import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/database/database_service.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/features/auth/views/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../widget/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Global function to show a SnackBar
void showSnackBar(BuildContext context, String message,
    {Color backgroundColor = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      dismissDirection: DismissDirection.horizontal,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(15),
      backgroundColor: backgroundColor,
    ),
  );
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final TextEditingController _dropDownSearchController =
      TextEditingController();
  String? _selectedHospital;
  bool obscurePassword = false;
  bool _rememberMe = false;
  Color? hospitalNumberFillColor = Colors.white70;
  Color? passwordFillColor = Colors.white70;
  Color? dropdownFill;
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> signingIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', true);
  }

  void navigateBackToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardView()),
    );
  }

  // Function to validate email format
  bool isValidEmail(String email) {
    final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegEx.hasMatch(email);
  }

  // Function to log in, show loading, and fetch user data
  Future<void> loginUser({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Attempt Firebase login
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Fetch user data from Firestore
      final String userId = userCredential.user!.uid;

      final userDoc = _firestore.collection("users").doc(userId);
      userDoc.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          // ...
          if (data != null) {
            final userData = UserData.fromMap(data);
            var res = await _databaseService.insertUserData(userData);
            if (res == "OK") {
              navigateBackToHome();
              final String userName =
                  userData.fullName ?? 'Unknown User'; // Access specific field
              showSnackBar(context, 'Welcome back, $userName!',
                  backgroundColor: Colors.green);
            } else {
              showSnackBar(context, '$res', backgroundColor: Colors.red);
            }
          } else {
            showSnackBar(context, 'User data is null.',
                backgroundColor: Colors.red);
          }
        },
        onError: (e) => {
          showSnackBar(context, "Error getting document: $e",
              backgroundColor: Colors.red),
          print("Error getting document: $e")
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that email.';
      }
      showSnackBar(context, errorMessage, backgroundColor: Colors.red);
    } finally {
      // Dismiss loading dialog
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void handleSignIn() {
    if (emailController.text.isEmpty) {
      showSnackBar(context, 'Email cannot be empty.');
      return;
    } else if (!isValidEmail(emailController.text)) {
      showSnackBar(context, 'Please enter a valid email address.');
      return;
    } else if (passwordController.text.isEmpty) {
      showSnackBar(context, 'Password cannot be empty.');
      return;
    } else if (_formKey.currentState!.validate()) {
      signingIn().then((_) {
        loginUser(
            context: context,
            emailController: emailController,
            passwordController: passwordController);
      });
    }
  }

  String? selectedHospital;
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  static final List<String> hospitalNames = [
    'Hospital A',
    'Hospital B',
    'Hospital C',
    'Hospital D',
    'Hospital E',
    'Hospital F',
    'Hospital G',
    'Hospital H',
    'Hospital I',
    'Hospital J',
    'Willowbrook General Hospital',
    'Havenridge Medical Center',
    'Serenity Health Clinic',
    'Crestview Regional Hospital',
    'Oakwood Community Hospital',
    'Meadowbrook Memorial Hospital',
    'Summitview Medical Center',
    'Pinecrest Hospital',
    'Harborview Healthcare Center',
    'Maplewood Clinic',
    'Sunridge Regional Hospital',
    'Lakeside Medical Center',
    'Rosewood General Hospital',
    'Valleyview Health Services',
    'Greenfield Community Hospital',
    'Riverside Medical Center',
    'Brookside Clinic',
    'Clearwater Hospital',
    'Mountainview Healthcare Center',
    'Fairview Regional Hospital'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(hospitalNames);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(
            fontSize: SizeMg.text(30),
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
        ),
        centerTitle: true,
        toolbarHeight: SizeMg.height(100),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeMg.width(25),
          right: SizeMg.width(25),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: SizeMg.text(25),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins-bold.ttf",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Enter your login details to access the app',
                style: TextStyle(
                  fontSize: SizeMg.text(18),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins-bold.ttf",
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(height: SizeMg.height(20)),
              TitleAndTextFormField(
                title: 'Email',
                formFieldHint: 'Please type your Email',
                formFieldController: emailController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                formFieldColor: hospitalNumberFillColor,
                formFieldValidator: (value) {
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    hospitalNumberFillColor = value.isNotEmpty
                        ? kFormTextDecoration.fillColor
                        : Colors.white70;
                  });
                },
              ),
              SizedBox(height: SizeMg.height(20)),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: SizeMg.text(18),
                  color: Colors.black,
                ),
              ),
              SizedBox(height: SizeMg.height(10)),
              TextFormField(
                obscureText: !obscurePassword,
                controller: passwordController,
                cursorHeight: SizeMg.height(19),
                decoration: kFormTextDecoration.copyWith(
                  errorBorder: kFormTextDecoration.errorBorder,
                  hintStyle: kFormTextDecoration.hintStyle,
                  filled: true,
                  fillColor: passwordFillColor,
                  border: kFormTextDecoration.border,
                  focusedBorder: kFormTextDecoration.focusedBorder,
                  hintText: "Type in your password",
                  suffixIcon: IconButton(
                    icon: obscurePassword
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.remove_red_eye_rounded),
                    iconSize: 24,
                    onPressed: () => setState(() {
                      obscurePassword = !obscurePassword;
                    }),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "The password field must cannot be empty";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    passwordFillColor = value.isNotEmpty
                        ? kFormTextDecoration.fillColor
                        : Colors.white70;
                  });
                },
              ),
              SizedBox(height: SizeMg.height(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text(
                    'Remember Me',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.navBarColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeMg.height(20)),
              PrimaryButton(
                width: double.infinity,
                buttonConfig: ButtonConfig(
                  text: 'Sign In',
                  action: () {
                    handleSignIn();
                  },
                  disabled: (_selectedHospital == '' ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty),
                ),
              ),
              SizedBox(height: SizeMg.height(30)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: SizeMg.width(8)),
                    child: Icon(
                      Icons.feedback_rounded,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: const TextSpan(
                        text: 'You don\'t have a Medherence account? ',
                        style: TextStyle(
                          letterSpacing: 0.3,
                          fontStyle: FontStyle.italic,
                          color: AppColors.darkGrey,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Reach out to your Healthcare Provider to enroll you on the platform',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.3,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
