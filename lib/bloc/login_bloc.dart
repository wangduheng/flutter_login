import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'package:flutter_firebase_login/validators.dart';
import 'package:meta/meta.dart';
import 'blocs.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        this._userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(Stream<LoginEvent> events,
      Stream<LoginState> Function(LoginEvent event) next) {
    print("event->$events");
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream
        .where((value) => value is! EmailChanged && value is! PasswordChanged);
    final debounceStream = observableStream
        .where((value) => value is EmailChanged || value is PasswordChanged)
        .debounceTime(Duration(milliseconds: 1000));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    }
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    }
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGoogleToState();
    }
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsToState(event.email, event.password);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
        isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithGoogleToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (e) {
      print("_mapLoginWithGoogleToState: $e");
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsToState(String email, String password) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (e) {
      print("_mapLoginWithCredentialsToState->$e");
      yield LoginState.failure();
    }
  }
}
