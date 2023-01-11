import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_training/firebase_options.dart';
import 'package:firebase_training/pages/top_page.dart';
import 'package:flutter/material.dart';

//Firebaseとの連携を以下に記述。以下のコードを含みアプリがビルドで切ればFirebaseとの連携が完了していることを意味する。
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(title: 'Flutter Demo Home Page'),
    );
  }
}
