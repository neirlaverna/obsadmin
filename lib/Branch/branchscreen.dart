import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:flutter/material.dart';

class BranchScreen extends StatelessWidget {
  const BranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding),
        child: Column(
          children: [
            Header(title: 'Daftar cabamg',),
          ],
        ),
      ),
    );
  }
}
