// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/account_screen.dart';
import 'package:seller/screens/dashboard_screen.dart';
import 'package:seller/screens/email_request.dart';
import 'package:seller/screens/deliveries_screen.dart';
import 'package:seller/screens/login_screen.dart';
import 'package:seller/screens/main_screen.dart';
import 'package:seller/screens/registration_screen.dart';
import 'package:seller/screens/reset_password_screen.dart';
import 'package:seller/screens/splash_screen.dart';
import 'package:seller/screens/waiting_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple.shade900,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (conext) => SplashScreen(),
        DeliveriesScreen.id: (context) => DeliveriesScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        RegisterYourEmail.id: (context) => RegisterYourEmail(),
        WaitingScreen.id: (context) => WaitingScreen(),
        MainScreen.id: (context) => MainScreen(),
        Dashboard.id: (context) => Dashboard(),
        AccountScreen.id: (context) => AccountScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
