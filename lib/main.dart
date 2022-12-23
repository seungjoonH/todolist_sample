import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist/firebase_options.dart';
import 'package:todolist/future.dart';
import 'package:todolist/home.dart';
import 'package:todolist/stream.dart';
import 'package:todolist/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 라이트 모드 테마 적용
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      // 다크 모드 테마 적용
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      initialRoute: '/',
      routes: {
        '/future': (context) => const FutureBuilderExamplePage(),
        '/stream': (context) => const StreamBuilderExamplePage(),
      },
      home: const HomePage(),
    );
  }
}