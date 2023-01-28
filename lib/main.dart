import 'package:diary/provider/diary_content_provider.dart';
import 'package:diary/provider/user_model_provider.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_generator.dart';
import 'package:diary/some_testing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModelProvider>(create: ((context) => UserModelProvider())),
        ChangeNotifierProvider<DiaryContentProvider>(create: ((context) => DiaryContentProvider()))
      ],
      child: MaterialApp(
        title: 'Diary',
        theme: ThemeData(primaryColor: MyAppTheme.primaryColor),
        onGenerateRoute: RouteGenerator.generate,
        home: const SomeTesting(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
