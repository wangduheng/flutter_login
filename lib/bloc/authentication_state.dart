import 'package:equatable/equatable.dart';
abstract class AuthenticationState extends Equatable{
  AuthenticationState({List prop=const []}):super(prop);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() {
    return 'Uninitialized{}';
  }
}

class Authenticated extends AuthenticationState {
  final String displayName;

  Authenticated(this.displayName) : super(prop: [displayName]);
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() {
    return 'Unauthenticated{}';
  }
}



