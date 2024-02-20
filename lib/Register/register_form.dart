import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool _loading = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    try {
      setState(() {
        _loading = true;
      });

      QuerySnapshot usernameQuery = await FirebaseFirestore.instance
          .collection('DataKaryawan')
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        setState(() {
          _loading = false;
        });
        _showAlertDialog(
            'Username telah digunakan, silahkan masukkan username lain');
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('DataKaryawan')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'email': email,
        'username': username,
        'admin': false,
      });

      _showAlertDialog('Registrasi Sukses!');
      

      QuerySnapshot emailQuery = await FirebaseFirestore.instance
          .collection('SuperAdmin')
          .get();

      Map<String, dynamic> data = emailQuery.docs.first.data() as Map<String, dynamic>;
      

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: data['email'], password: data['pass']);
      setState(() {
        _loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });

      if (e.message ==
          'An unknown error occurred: FirebaseError: Firebase: The email address is already in use by another account. (auth/email-already-in-use).') {
        _showAlertDialog('Email sudah terdaftar, silahkan gunakan email lain!');
      } else {
        _showAlertDialog('Error: ${e.message}');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      _showAlertDialog('Error: ${e.toString()}');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 500,
        child: Center(
          child: SizedBox(
            width: 300,
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (RawKeyEvent event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  FocusScope.of(context).nextFocus();
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Registrasi pengguna baru',
                      style: TextStyle(
                        fontFamily: 'Libre',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Masukkan email....",
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        return "Username tidak boleh kosong";
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Masukkan username....",
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: obscureText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  const SizedBox(
                    height: 15,
                  ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 63, 34, 129),
                            Color.fromARGB(255, 26, 80, 82),
                            Color.fromARGB(255, 76, 29, 90),
                          ]),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Libre',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
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