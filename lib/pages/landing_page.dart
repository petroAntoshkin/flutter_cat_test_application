
import 'package:cat_test_app/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';
import 'sign_in_page.dart';

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
        setState(() { _user = state.user;});
      },
      child: _user == null
          ? SignInPage()
          : MyHomePage(),
    );
  }
}
