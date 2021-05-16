import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_event.dart';

part 'login_state.dart';

class AuthBloc extends Bloc<LoginEvent, LoginState> {
  User _currentUser;
  User get currentUser{
    _currentUser = _firebaseAuth.currentUser;
    return _currentUser;
  }
  set currentUser(User user){
    // _currentUser = _firebaseAuth.currentUser;
    _currentUser = user;
  }
  final _firebaseAuth = FirebaseAuth.instance;

  AuthBloc(initialState) : super(initialState);

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitGoogle) {
      yield* _mapGoogleLogin(event);
    } else if (event is LoginSubmitFacebook) {
      yield* _mapFacebookLogin(event);
    } else if (event is LogOut) {
      yield* _logOut(event);
    }
  }

  Stream<LoginState> _mapGoogleLogin(LoginSubmitGoogle event) async* {
    if (state is! LoginProcessing) {
      // yield state.copyWith(user: null);
      try {
        await _signInWithGoogle();
        currentUser = _firebaseAuth.currentUser;
        yield state;
      } on Exception catch (_) {
        // yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Stream<LoginState> _mapFacebookLogin(LoginSubmitFacebook event) async* {
    if (state is! LoginProcessing) {
      // yield state;
      try {
        await _signInWithFacebook();
        // await _signInWithFacebookAlternative();
        currentUser = _firebaseAuth.currentUser;
        yield state;
      } on Exception catch (_) {
        // yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        currentUser = _firebaseAuth.currentUser;
        // return userCredential.user;
      }
    } else {
      throw UnimplementedError();
    }
  }

  // Future<void> _signInWithFacebookAlternative() async  {
  //   final facebookLogin = FacebookLogin();
  //   final result = await facebookLogin.logIn(['email']);//.logInWithReadPermissions(['email']);
  //   switch (result.status) {
  //       case FacebookLoginStatus.loggedIn:
  //         final accessToken = result.accessToken;
  //         final userCredential = await _firebaseAuth.signInWithCredential(
  //             FacebookAuthProvider.credential(accessToken.token));
  //         // return userCredential.user;
  //         break;
  //       case FacebookLoginStatus.cancelledByUser:
  //         throw FirebaseAuthException(
  //             code: 'ERROR_ABORTED_BY_USER', message: 'Aborted by user');
  //       case FacebookLoginStatus.error:
  //         throw FirebaseAuthException(
  //             code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //             message: result.errorMessage);
  //       default:
  //         throw UnimplementedError();
  //     }
  //
  // }
  Future<void> _signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        // return userCredential.user;
        break;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Aborted by user');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: response.error.developerMessage);
      default:
        throw UnimplementedError();
    }
  }

  Stream<LoginState> _logOut(LogOut event) async* {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final fbLogin = FacebookLogin();
    await fbLogin.logOut();
    await _firebaseAuth.signOut();
    // yield state;
  }
}
