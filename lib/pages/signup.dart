import 'package:car_repair_service/login/login.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Регистрация", style: Theme.of(context).textTheme.title),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: SignupForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearController(_nameController);
    clearController(_surnameController);
    clearController(_phoneController);
    clearController(_emailController);
    clearController(_passwordController);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            autocorrect: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните Фамилию';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            controller: _surnameController,
            decoration: InputDecoration(
              labelText: "Фамилия",
            ),
          ),
          TextFormField(
            autocorrect: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните Имя';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Имя",
            ),
          ),
          TextFormField(
            autocorrect: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните Телефон';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: "Телефон",
            ),
          ),
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
            onPressed: () async {
              final store = StoreProvider.of<AppState>(context);
              final auth = store.state.auth;
              if (!_formKey.currentState.validate()) return;
              if (_emailController.text.length == 0 ||
                  _passwordController.text.length == 0) return;
              final userId = await auth.signUp(
                  _emailController.text, _passwordController.text);

              if (userId.length == 0) return;
              final user = await auth.getCurrentUser();
              store.dispatch(UpdateUser(user));
              store.dispatch(ChangeAuthStatus(AuthStatus.LOGGED_IN));
              store.dispatch(CreateUserInfo(UserInfo(
                  userID: user.uid,
                  email: _emailController.text,
                  name: _nameController.text,
                  surname: _surnameController.text,
                  phone: _phoneController.text)));
              Navigator.of(context).pushReplacementNamed("/menu");
            },
            child: Text("Зарегистрироваться"),
            textColor: Colors.white,
          ),
        ],
      ), // Build this out in the next steps.
    );
  }
}
