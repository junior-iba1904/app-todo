import 'package:app_todo/core/config/style/theme.dart';
import 'package:app_todo/feature/home/presentation/provider/theme_provider.dart';
import 'package:app_todo/feature/home/presentation/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: light,
      darkTheme: dark,
      themeMode: themeMode,
      home: const Home(),
    );
  }
}
