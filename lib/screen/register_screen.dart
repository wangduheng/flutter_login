import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/bloc/blocs.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/widget/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
//      body:Center(child: BlocBuilder(bloc: RegisterBloc(_userRepository),builder: (context,state){
//
//      },),)
      body: Center(
        child: BlocProvider(
          builder: (context) => RegisterBloc(_userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
