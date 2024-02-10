import 'package:desktopadmin/constans.dart';
import 'package:desktopadmin/header.dart';
import 'package:desktopadmin/newtransaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding),
        child: Column(
          children: [
            Header(),
            NewTransaction(flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin,)
          ],
        ),
      ),
    );
  }
}

