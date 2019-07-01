import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent({List prop = const []}) : super(prop);
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({this.email}) : super(prop: [email]);

  @override
  String toString() {
    return 'EmailChanged{email: $email}';
  }
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({this.password}) : super(prop: [password]);

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

class LoginWithGooglePressed extends LoginEvent {
  @override
  String toString() {
    return 'LoginWithGooglePressed{}';
  }
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({this.email, this.password})
      : super(prop: [email, password]);

  @override
  String toString() {
    return 'LoginWithCredentialsPressed{email: $email, password: $password}';
  }


}
