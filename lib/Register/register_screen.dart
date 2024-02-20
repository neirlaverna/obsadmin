import 'package:desktopadmin/Register/register_form.dart';
import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:desktopadmin/Services/firebase_services.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseServiceSuperAdmin _superAdminService =
      FirebaseServiceSuperAdmin();

  @override
  Widget build(BuildContext context) {
    // Dapatkan email pengguna yang saat ini terautentikasi
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userEmail = currentUser?.email ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding),
        child: Column(
          children: [
            Header(
              title: 'Daftar Karyawan',
            ),
            FutureBuilder<String?>(
              future: _superAdminService.getSuperadminByEmail(userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String? superAdminValue = snapshot.data;
                  bool isSuperAdmin = superAdminValue == 'true';
                  return isSuperAdmin ? RegisterForm() : SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
