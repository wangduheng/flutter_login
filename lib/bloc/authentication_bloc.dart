import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRespository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRespository = userRepository;

  @override
  AuthenticationState get initialState => Unauthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* mapAppStartedToState();
    }
    if (event is LoggedIn) {
      yield* mapLogginToState();
    }
    if (event is LoggedOut) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRespository.signOut();
  }

  Stream<AuthenticationState> mapLogginToState() async* {
    yield Authenticated(await _userRespository.getUser());
  }

  Stream<AuthenticationState> mapAppStartedToState() async* {
    try {
      bool isSignedIn = await _userRespository.isSignedIn();
      if (isSignedIn) {
        String userName = await _userRespository.getUser();
        yield Authenticated(userName);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }
}
