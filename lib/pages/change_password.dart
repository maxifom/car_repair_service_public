import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearController(_oldPasswordController);
    clearController(_newPasswordController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Сменить пароль", style: Theme.of(context).textTheme.title),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: ChangePasswordForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  @override
  ChangePasswordFormState createState() => ChangePasswordFormState();
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearController(_oldPasswordController);
    clearController(_newPasswordController);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните Пароль';
              }
              return null;
            },
            obscureText: true,
            controller: _oldPasswordController,
            decoration: InputDecoration(
              labelText: "Старый пароль",
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните Пароль';
              }
              return null;
            },
            obscureText: true,
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: "Новый пароль",
            ),
          ),
          SizedBox(height: 32),
          RaisedButton(
            onPressed: () async {
              var store = StoreProvider.of<AppState>(context);
              final auth = store.state.auth;
              if (!_formKey.currentState.validate()) return;
              final oldPassword = _oldPasswordController.text;
              if (oldPassword.length == 0 ||
                  _newPasswordController.text.length == 0) {
                return;
              }
              var userID = await auth.signIn(store.state.user.email,
                  oldPassword);
              if (userID.length == 0) {
                return;
              }

              await store.state.user
                  .updatePassword(_newPasswordController.text);
              Navigator.of(context).pushNamed("/menu");
            },
            child: Text("Сменить пароль"),
            textColor: Colors.white,
          ),
        ],
      ), // Build this out in the next steps.
    );
  }
}
