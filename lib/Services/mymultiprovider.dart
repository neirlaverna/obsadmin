import 'package:desktopadmin/Main/mainscreen.dart';
import 'package:desktopadmin/Services/menucontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter

class MyMultiProvider extends StatefulWidget {
  const MyMultiProvider({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyMultiProvider> createState() => _MyMultiProviderState();
}

class _MyMultiProviderState extends State<MyMultiProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: const MainScreen(),
    );
  }
}
