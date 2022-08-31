import 'package:flutter/material.dart';
import 'package:mvvm_sqlite_demo/ui/login/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mvvm_sqlite_demo/ui/student/student_screen.dart';

import 'utils/prefs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Prefs.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVVM Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
    );
  }
}

