import 'package:LittleBuddy/views/home.dart';
import 'package:LittleBuddy/views/signUp_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../model/profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final uid = user?.uid;
final FirebaseFirestore _db = FirebaseFirestore.instance;

class Role {
  String role;

  Role(this.role);

  factory Role.fromUserSnapshot(
      DocumentSnapshot<Map<String, dynamic>> userSnapshot) {
    final String role = userSnapshot.get('role');
    return Role(role);
  }
}

Role? globalRole;

Future<void> getUserRole() async {
  final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _db.collection('userdatabase').doc(uid).get();
  if (userSnapshot.exists) {
    final Role role = Role.fromUserSnapshot(userSnapshot);
    globalRole = role; // กำหนดค่า globalRole
  } else {
    throw Exception("User not found");
  }
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final SimpleUIController simpleUIController = Get.put(SimpleUIController());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Profile profile = Profile(email: '', password: '');

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Login',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome to littleBuddy',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.isEmail) {
                      nameController.clear();
                      return 'Please enter email';
                    }
                    profile.email = value;
                    return null;
                  },
                ),
                // SizedBox(
                //   height: size.height * 0.02,
                // ),
                // TextFormField(
                //   controller: emailController,
                //   decoration: const InputDecoration(
                //     prefixIcon: Icon(Icons.email_rounded),
                //     hintText: 'gmail',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter gmail';
                //     } else if (!value.endsWith('@gmail.com')) {
                //       return 'please enter valid gmail';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length < 7) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      profile.password = value;
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpView()),
                    );
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: " Sign up",
                          style: kLoginOrSignUpTextStyle(
                            size,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                gobackButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showAlert() {
    QuickAlert.show(
        context: context,
        title: "Wrong email or password",
        type: QuickAlertType.error);
  }

  Future<void> showAlert2(BuildContext context) async {
    await QuickAlert.show(
        context: context, title: "Login Success", type: QuickAlertType.success);
  }

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () async {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              try {
                // Call Firebase Auth signInWithEmailAndPassword method
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: profile.email,
                  password: profile.password,
                );

                await getUserRole();

                // Show alert if login success
                await showAlert2(context);

                // Navigate to Home screen after login success
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              } on FirebaseAuthException catch (e) {
                // Show error message if login failed
                if (e.code == 'user-not-found') {
                  showAlert();
                } else if (e.code == 'wrong-password') {
                  showAlert();
                }
              } catch (e) {
                print(e);
              }
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }

  Widget gobackButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: const Text(
            'Go back to menu',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }
}

void initializeApp() async {
  await getUserRole();
}
