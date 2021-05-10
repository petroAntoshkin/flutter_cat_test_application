import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat_test_application/bloc/auth_bloc.dart';
import 'package:flutter_cat_test_application/elements/fb_icon.dart';
import 'package:flutter_cat_test_application/elements/sign_in_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Cat Test App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            _GoogleButton(),
            SizedBox(
              height: 10.0,
            ),
            _FacebookButton(),
          ],
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, LoginState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state == LoginProcessing()
            ? const CircularProgressIndicator()
            : SignInButton(
                icon: SvgPicture.asset(
                  'assets/svg/google_icon.svg',
                ),
                text: 'Sign in with Google',
                color: Colors.white,
                borderRadius: 8.0,
                onPressHandler: () => context.read<AuthBloc>().add(LoginSubmitGoogle()),
              );
      },
    );
  }
}
class _FacebookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, LoginState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state == LoginProcessing()
            ? const CircularProgressIndicator()
            : SignInButton(
          icon: FBIcon(),
          text: 'Sign in with Facebook',
          color: Color(0xFFCCECF5),
          //   color: Color(0xFFCCECF5),
          //   // color: Color(0xff1877F2),
          //   // color: Color(0xff2851A3),
                borderRadius: 8.0,
                onPressHandler: () => context.read<AuthBloc>().add(LoginSubmitFacebook()),
              );
      },
    );
  }
}
