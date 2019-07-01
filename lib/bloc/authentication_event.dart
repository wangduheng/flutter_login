import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent({List prop = const []}) : super(prop);
}

class AppStarted extends AuthenticationEvent{
  @override
  String toString() {
    return 'AppStarted{}';
  }

}

class LoggedIn extends AuthenticationEvent{
  @override
  String toString() {
    return 'LoggedIn{}';
  }
}

class LoggedOut extends AuthenticationEvent{

  @override
  String toString() {
    return 'LoggedOut{}';
  }
}