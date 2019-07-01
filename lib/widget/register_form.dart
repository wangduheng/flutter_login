import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/bloc/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterBtnEnabled(RegisterState state) =>
      state.isFromValid && isPopulated && !state.isSubmitting;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _registerBloc,
      listener: (context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Registering"),
                CircularProgressIndicator()
              ],
            )));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          Navigator.pop(context);
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Registration Failure'),
                    Icon(Icons.error)
                  ],
                )));
        }
      },
      child: BlocBuilder(
          bloc: _registerBloc,
          builder: (context, RegisterState state) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                  child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? "Invalid Email" : null;
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: "Email"),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? "Invalid Password" : null;
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: "Password"),
                  ),
                  RegisterButton(
                    onPressed:
                        isRegisterBtnEnabled(state) ? _formSubmitted : null,
                  ),
                ],
              )),
            );
          }),
    );
  }

  void _formSubmitted() {
    _registerBloc.dispatch(RSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
  }

  void _emailListener() {
    _registerBloc.dispatch(REmailChanged(email: _emailController.text));
  }

  void _passwordListener() {
    _registerBloc
        .dispatch(RPasswordChanged(password: _passwordController.text));
  }
}
