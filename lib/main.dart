import 'package:chat_sphere/firebase_options.dart';
import 'package:chat_sphere/ui/auth_screen.dart';
import 'package:chat_sphere/ui/chat/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Sphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool? _signedIn = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _signedIn = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_signedIn == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_signedIn!) {
      return Chat(onSignOut: () {
        FirebaseAuth.instance.signOut();
      });
    } else {
      return AuthScreen();
    }
  }
}

