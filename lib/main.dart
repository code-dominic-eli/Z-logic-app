import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/input_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure portrait constraint
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Z Logic',
      theme: AppTheme.darkTheme,
      home: const InputScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
