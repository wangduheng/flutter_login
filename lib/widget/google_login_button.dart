import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/bloc/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: () => BlocProvider.of<LoginBloc>(context)
          .dispatch(LoginWithGooglePressed()),
      icon: Icon(
        FontAwesomeIcons.google,
        color: Colors.white,
      ),
      label: Text(
        "Sign in with google",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
