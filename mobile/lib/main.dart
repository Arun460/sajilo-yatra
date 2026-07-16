import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await dotenv.load(fileName: ".env");
  runApp(const SajiloYatraApp());
}

class SajiloYatraApp extends StatelessWidget {
  const SajiloYatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sajilo Yatra',
      theme: AppTheme.theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}