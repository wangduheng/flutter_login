import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'package:flutter_firebase_login/screen/screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        this.userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RegisterScreen(userRepository: userRepository);
          }));
        },
        child: Text("Create an Account"));
  }
}
