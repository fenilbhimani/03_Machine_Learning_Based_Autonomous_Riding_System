import 'package:carapp/pages/home.dart';
import 'package:carapp/pages/sign_in.dart';
import 'package:carapp/pages/spash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahara',
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
      home:
      StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder:(ctx,snapshot){

        if(snapshot.hasData)
        {
          return FirebaseAuth.instance.currentUser != null ? const Home() : const SplashScreen();
        }
        return SignIn();
      }),
    );
  }
}
