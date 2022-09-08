import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/providers/status.dart';
import 'package:notes/screens/authenticate/reset_password.dart';
import 'package:notes/screens/authenticate/sign_up.dart';
import 'package:notes/screens/notes/add_notes.dart';
import 'package:notes/screens/notes/edit_notes.dart';
import 'package:notes/screens/home/home.dart';
import 'package:notes/screens/nickname.dart';
import 'package:notes/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthStatus>(create: (_) => AuthStatus()),
    ChangeNotifierProvider<FireStoreProvider>(
        create: (_) => FireStoreProvider()),
  ], child: const Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/home': (context) => const HomePage(),
        '/nickname': (context) => NickName(),
        '/resetpwd': (context) => const ResetPassWord(),
        '/addnotes': (context) => AddNotes(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
