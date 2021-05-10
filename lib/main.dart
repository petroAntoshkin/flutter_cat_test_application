import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat_test_application/pages/landing_page.dart';

import 'bloc/auth_bloc.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cat Test Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // home: MyHomePage(title: 'Flutter Cat Test Application'),
      home: BlocProvider(
        create: (context){
          return AuthBloc(const LoginState());
        },
        child: LandingPage(),
      ),
    );
  }
}


