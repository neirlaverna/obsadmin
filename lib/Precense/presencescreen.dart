import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:flutter/material.dart';

class PresenceScreen extends StatelessWidget {
  const PresenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding),
        child: Column(
          children: [
            Header(title: 'Presensi Kehadiran',),
          ],
        ),
      ),
    );
  }
}
