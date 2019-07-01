import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_login/bloc/blocs.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'package:flutter_firebase_login/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc(UserRepository userRepository)
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transform(Stream<RegisterEvent> events,
      Stream<RegisterState> Function(RegisterEvent event) next) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where(
            (value) => value is! REmailChanged && value is! RPasswordChanged);
    final debounceStream = observableStream
        .where((value) => value is REmailChanged || value is RPasswordChanged)
        .debounceTime(Duration(milliseconds: 300));

    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event,) async* {
    if (event is REmailChanged) {
      yield* mapREmailChangedToState(event.email);
    }
    if (event is RPasswordChanged) {
      yield* mapRPasswordChangedToState(event.password);
    }
    if (event is RSubmitted) {
      yield* mapRSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> mapREmailChangedToState(String email) async* {
    yield currentState.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> mapRPasswordChangedToState(String password) async* {
    yield currentState.update(
        isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> mapRSubmittedToState(String email,
      String password) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email: email, password: password);
      yield RegisterState.success();
    } catch (e) {
      print("submited->$e");
      yield RegisterState.failure();
    }
  }
}
