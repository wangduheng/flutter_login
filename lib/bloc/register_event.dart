import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class REmailChanged extends RegisterEvent {
  final String email;

  REmailChanged({@required this.email}) : super([email]);

  @override
  String toString() {
    return 'REmailChanged{email: $email}';
  }
}

class RPasswordChanged extends RegisterEvent {
  final String password;

  RPasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() {
    return 'RPasswordChanged{password: $password}';
  }
}

class RSubmitted extends RegisterEvent {
  final String email;
  final String password;

  RSubmitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'RSubmitted{email: $email, password: $password}';
  }
}
