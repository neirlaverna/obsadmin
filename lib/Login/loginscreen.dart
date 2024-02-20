import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:desktopadmin/Services/authservices.dart';
import 'package:desktopadmin/Login/loginwidget.dart';
import 'package:desktopadmin/Main/mainscreen.dart';
import 'package:desktopadmin/Services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

Future<void> _handleLogin(BuildContext context) async {
  setState(() {
    isLoading = true;
  });

  String? adminStatus = await FirebaseServiceAdmin().getadminByEmail(emailController.text.trim());

  if (adminStatus == 'false') {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.blueGrey,
          backgroundColor: Colors.black87,
          titleTextStyle: const TextStyle(
              fontFamily: 'Teko',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          contentTextStyle: const TextStyle(
              fontFamily: 'CG',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white),

          content: const Text(
              "Anda tidak bisa masuk menggunakan aplikasi WEB.\nSilahkan masuk melalui Mobile karena Anda bukan admin."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    setState(() {
      isLoading = false;
    });
    return;
  }


  final userCredential = await _authService.signInWithEmailAndPassword(
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  if (userCredential != null && FirebaseAuth.instance.currentUser != null) {
    User user = userCredential;
    // ignore: deprecated_member_use
    await user.updateProfile(displayName: 'UsernamePengguna');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  } else {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.blueGrey,
          backgroundColor: Colors.black87,
          titleTextStyle: const TextStyle(
              fontFamily: 'Teko',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          contentTextStyle: const TextStyle(
              fontFamily: 'CG',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white),
          title: const Text("Kesalahan login"),
          content: const Text(
              "Email atau password salah, silahkan periksa kembali"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  setState(() {
    isLoading = false;
  });
}
  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 4,
      progressIndicator: const SpinKitFadingCircle(
        color: Color.fromARGB(255, 86, 179, 202),
        size: 90.0,
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black87,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/dark_pattern.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 80, bottom: 30),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontFamily: 'BlackOpsOne',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'OBLO STORE',
                                      speed: const Duration(milliseconds: 200),
                                    ),
                                  ],
                                  repeatForever: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 500,
                              width: 400,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(32, 235, 235, 235),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(1, 4),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontFamily: 'Teko',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    LoginForm(
                                      emailController: emailController,
                                      passwordController: passwordController,
                                      handleLogin: _handleLogin,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
