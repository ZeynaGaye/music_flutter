import 'package:flutter/material.dart';
import 'package:musicc/App.dart';
import 'package:musicc/musicProvider/AudioPlayerProvider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioPlayerProvider>(
          create: (_) => AudioPlayerProvider(), // Replace AudioProvider() with your actual provider instantiation logic
        ),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
      ),
      home: App(),
    );
  }
}

