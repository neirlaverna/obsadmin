import 'dart:js' as js;
import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Services/firebase_options.dart';
import 'package:desktopadmin/Login/loginscreen.dart';
import 'package:desktopadmin/Services/menucontroller.dart';
import 'package:desktopadmin/Services/mymultiprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
    js.context.callMethod('allowPermission');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  String? _currentUserId;
  String? _currentToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            _currentUserId = FirebaseAuth.instance.currentUser!.uid;
            _getCurrentToken();
            
            return const MyMultiProvider(title: 'Tesdrive',);
          }
          return const LoginScreen();
        },
      ),
    );
  }

  void _getCurrentToken() async {
    String? initialToken = await FirebaseMessaging.instance.getToken();
    _currentToken = initialToken;
    saveTokenToDatabase(_currentUserId, _currentToken!);
  }
}

void saveTokenToDatabase(String? userId, String token) {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('admintoken').child('token').update({
    'fcmToken': token,
  });
}


