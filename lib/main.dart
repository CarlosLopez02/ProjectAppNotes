import 'package:appdenotas/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:appdenotas/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
 
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
  
      title: 'Notas Rápidas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 
