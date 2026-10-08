import 'package:flutter/material.dart';
import 'login_screen.dart';

void main(){runApp(const PingLoopApp());}

class PingLoopApp extends StatelessWidget{
  const PingLoopApp({super.key});
  @override Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:'PINGLOOP',
      theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF164A4A)),scaffoldBackgroundColor:const Color(0xFFE8F7F7)),
      home:const LoginScreen(),
    );
  }
}
