part of 'auth_bloc.dart';

abstract class LoginEvent  {
  const LoginEvent();
}

class LoginProcessing extends LoginEvent {
  const LoginProcessing();
}

class LoginSubmitGoogle extends LoginEvent {
  const LoginSubmitGoogle();
}
class LoginSubmitFacebook extends LoginEvent {
  const LoginSubmitFacebook();
}

class LogOut extends LoginEvent{
  const LogOut();
}