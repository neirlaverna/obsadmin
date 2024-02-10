import 'package:desktopadmin/constans.dart';
import 'package:desktopadmin/header.dart';
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
            Header(),
          ],
        ),
      ),
    );
  }
}
