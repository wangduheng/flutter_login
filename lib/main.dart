import 'package:flutter/material.dart';

import 'bloc/blocs.dart';
import 'repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'screen/screen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    builder: (context) {
      return AuthenticationBloc(userRepository: userRepository)
        ..dispatch(AppStarted());
    },
    child: MyApp(
      userRepository: userRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder(
          bloc: BlocProvider.of<AuthenticationBloc>(context),
          builder: (context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashScreen();
            } else if (state is Authenticated) {
              return HomeScreen(name: state.displayName,);
            }else if(state is Unauthenticated){
              return LoginScreen(userRepository: _userRepository);
            }
            return Container();
          }),
    );
  }
}
