import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/bloc/blocs.dart';
import 'package:flutter_firebase_login/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/widget/widgets.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        this._userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginBtnEnabled(LoginState state) {
    return state.isFromValid && isPopulated && !state.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (context, LoginState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                  children: <Widget>[Text('login Failure'), Icon(Icons.error)],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )));
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              children: <Widget>[
                Text("Logging in"),
                CircularProgressIndicator()
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder(
          bloc: _loginBloc,
          builder: (context, LoginState state) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                  child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FlutterLogo(
                      size: 200,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return state.isEmailValid ? null : 'Invalid Email';
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    autovalidate: true,
                    autocorrect: false,
                    obscureText: true,
                    validator: (_) {
                      return state.isPasswordValid ? null : 'Invalid password';
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Password'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                            onPressed: isLoginBtnEnabled(state)
                                ? _onFormSubmitted
                                : null),
                        GoogleLoginButton(),
                        CreateAccountButton(userRepository: _userRepository)
                      ],
                    ),
                  )
                ],
              )),
            );
          }),
    );
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
    super.initState();
  }

  void _passwordListener() {
    _loginBloc.dispatch(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  void _emailListener() {
    _loginBloc.dispatch(EmailChanged(email: _emailController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
