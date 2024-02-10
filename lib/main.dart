import 'package:desktopadmin/constans.dart';
import 'package:desktopadmin/firebase_options.dart';
import 'package:desktopadmin/loginscreen.dart';
import 'package:desktopadmin/menucontroller.dart';
import 'package:desktopadmin/mymultiprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MyApp(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final flutterLocalNotificationsPlugin;

  MyApp({Key? key, required this.flutterLocalNotificationsPlugin}) : super(key: key);

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
            return const MyMultiProvider();
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
  final databaseReference = FirebaseDatabase.instance.reference();
  databaseReference.child('admintoken').child('token').update({
    'fcmToken': token,
  });
}
