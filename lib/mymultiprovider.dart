import 'package:desktopadmin/mainscreen.dart';
import 'package:desktopadmin/menucontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMultiProvider extends StatefulWidget {
  const MyMultiProvider({Key? key});

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
