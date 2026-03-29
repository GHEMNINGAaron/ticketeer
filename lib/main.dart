import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticketeer/screen/auth_warapper.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/providers/auth_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB10n5u8MiYVuWcvKh0FsthdyvVY9RCoIU",
      authDomain: "ticketeer-eb1eb.firebaseapp.com",
      projectId: "ticketeer-eb1eb",
      storageBucket: "ticketeer-eb1eb.firebasestorage.app",
      messagingSenderId: "59753976979",
      appId: "1:59753976979:web:01a850e288be049cbb2966"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Ticketeer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          brightness: Brightness.dark,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}