import 'package:car_repair_service/login/login.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Вход", style: Theme.of(context).textTheme.title),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoggingIn = false;

  @override
  dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _login() async {
    final store = StoreProvider.of<AppState>(context);
    final auth = store.state.auth;
    if (!_formKey.currentState.validate()) return;
    if (_emailController.text.length == 0 ||
        _passwordController.text.length == 0) return;
    setState(() {
      _isLoggingIn = true;
    });
    try {
      var userId = await auth
          .signIn(_emailController.text, _passwordController.text)
          .timeout(Duration(seconds: 10));
      if (userId.length == 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Что-то пошло не так"),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        return;
      }
      var user = await auth.getCurrentUser();
      if (user == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Что-то пошло не так"),
          backgroundColor: Theme.of(context).primaryColor,
        ));
        return;
      }
      store.state.db
          .child("users/${user.uid}")
          .once()
          .then((DataSnapshot snapshot) {
        store.dispatch(UpdateUserInfo(UserInfo.fromSnapshot(snapshot)));
      });
      store.dispatch(UpdateUser(user));
      store.dispatch(ChangeAuthStatus(AuthStatus.LOGGED_IN));
      Navigator.of(context).pushReplacementNamed("/menu");
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Такого юзера не существует"),
            backgroundColor: Theme.of(context).primaryColor,
          ));
          break;
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_INVALID_EMAIL':
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Неправильные почта или пароль"),
            backgroundColor: Theme.of(context).primaryColor,
          ));
          break;
        default:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Что-то пошло не так"),
            backgroundColor: Theme.of(context).primaryColor,
          ));
          print(e);
          break;
      }
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  void initState() {
    clearController(_emailController);
    clearController(_passwordController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoggingIn
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                TextFormField(
                  autocorrect: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Заполните Почту';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Почта",
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Заполните Пароль';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Пароль",
                  ),
                ),
                SizedBox(height: 32),
                RaisedButton(
                  onPressed: _login,
                  child: Text("Войти"),
                  textColor: Colors.white,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/signup");
                  },
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Зарегистрироваться"),
                )
              ],
            ),
    );
  }
}
