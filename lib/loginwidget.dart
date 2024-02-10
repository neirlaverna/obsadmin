import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(BuildContext) handleLogin;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.handleLogin,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}
class KeyboardUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
class _LoginFormState extends State<LoginForm> {
  bool obscureText = true;
  late FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleEmailSubmitted(String value) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  void _handlePasswordSubmitted(String value) {

    KeyboardUtils.hideKeyboard(context);

    widget.handleLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: widget.emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty || value == "") {
              return "Email tidak boleh kosong";
            } else if (!value.trim().contains("@")) {
              return "Email tidak sesuai";
            }
            return null;
          },
          onSaved: (value) {},
          textInputAction: TextInputAction.next,
          onFieldSubmitted: _handleEmailSubmitted, 
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: "Masukkan email....",
            hintStyle: const TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: widget.passwordController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          focusNode: _passwordFocus,
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.trim().isEmpty || value == "") {
              return "Password tidak boleh kosong";
            } else if (value.trim().length < 6) {
              return "Password harus terdiri dari 6 karakter";
            }
            return null;
          },
          onSaved: (value) {},
          textInputAction: TextInputAction.done,
          onFieldSubmitted: _handlePasswordSubmitted,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: "Masukkan Password....",
            hintStyle: const TextStyle(color: Colors.white70),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(
                obscureText
                    ? Icons.remove_red_eye_rounded
                    : Icons.remove_red_eye_outlined,
                color: Colors.white60,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 60, 44, 133),
                  Color.fromARGB(255, 23, 35, 58),
                  Color.fromARGB(255, 43, 24, 80),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: GestureDetector(
              child: const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'CG',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                widget.handleLogin(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
