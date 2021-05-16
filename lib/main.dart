import 'package:cat_test_app/pages/landing_page.dart';
import 'package:cat_test_app/provider/cats_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => CatsProvider(),
      child: Consumer<CatsProvider>(
          builder: (context, CatsProvider notifier, child) {
            return MaterialApp(
              title: 'Cat Api Application',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              debugShowCheckedModeBanner: false,
              home: BlocProvider(
                create: (context){
                  return AuthBloc(const LoginState());
                },
                child: LandingPage(),
              ),
            );
          }),
    );
  }
}
