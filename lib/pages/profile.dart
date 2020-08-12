import 'package:after_layout/after_layout.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<ProfilePage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  UserInfo userInfo;

  @override
  void initState() {
    super.initState();
    clearController(_nameController);
    clearController(_surnameController);
    clearController(_phoneController);
    clearController(_emailController);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    this.userInfo = store.state.userInfo;
    _nameController.text = userInfo.name;
    _surnameController.text = userInfo.surname;
    _emailController.text = userInfo.email;
    _phoneController.text = userInfo.phone;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Профиль',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image: new Image.network(
                                  "https://picsum.photos/id/1027/200/200")
                              .image,
                          fit: BoxFit.fill,
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(36.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextField(
                    enabled: false,
                    readOnly: true,
                    style: TextStyle(color: Colors.grey.shade500),
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Почта",
                    ),
                  ),
                  TextField(
                    enabled: false,
                    readOnly: true,
                    style: TextStyle(color: Colors.grey.shade500),
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Телефон",
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: "Фамилия",
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Имя",
                    ),
                  ),
                  SizedBox(height: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          final store = StoreProvider.of<AppState>(context);
                          if (_surnameController.text != userInfo.surname ||
                              _nameController.text != userInfo.name) {
                            final userInfo = UserInfo(
                              userID: this.userInfo.userID,
                              email: this.userInfo.email,
                              name: _nameController.text,
                              surname: _surnameController.text,
                              phone: this.userInfo.phone,
                            );
                            saveUserInfo(userInfo, store.state.db);
                            store.dispatch(UpdateUserInfo(userInfo));
                          }
                        },
                        child: Text("Сохранить"),
                        textColor: Colors.white,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/change-password");
                        },
                        child: Text("Сменить пароль"),
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
