import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat_test_application/bloc/auth_bloc.dart';
import 'package:flutter_cat_test_application/pages/home_page.dart';
import 'package:flutter_cat_test_application/pages/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    User _user = context.read<AuthBloc>().currentUser;
    // print('--------------------------landing page build');
    return BlocListener<AuthBloc, LoginState>(
      listener: (context, state) {
        // print('------------------ landing page listener');
        setState(() {});
      },
      child: _user == null
          ? SignInPage()
          : MyHomePage(),
    );
  }
}
