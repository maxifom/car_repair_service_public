import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:car_repair_service/login/login.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AfterLayoutMixin<MenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void afterFirstLayout(BuildContext context) async {
    var store = StoreProvider.of<AppState>(context);
    // Чтобы обновились email/name, которые асинхронно забираются из базы
    await store.onChange.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    String name = "";
    String email = "";
    final user = store.state.userInfo;
    if (user != null) {
      name = user.name;
      email = user.email;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(Icons.menu),
          textColor: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          "MazdaPro",
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          Container(
            child: Center(
              child: RaisedButton(
                onPressed: null,
                disabledTextColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "0",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
                    ),
                    Icon(
                      Icons.monetization_on,
                      size: 18,
                    )
                  ],
                ),
                disabledColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).pushNamed("/order");
                },
                icon: Icon(Icons.edit),
                label: Text("Запись на обслуживание"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).pushNamed("/history");
                },
                icon: Icon(Icons.history),
                label: Text("История обслуживания"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () async {
                  await launchURL("http://mazda-pro.ru");
                },
                icon: Icon(Icons.store),
                label: Text("Магазин автозапчастей"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).pushNamed("/bonus");
                },
                icon: Icon(Icons.attach_money),
                label: Text("Бонусная программа"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).pushNamed("/sale");
                },
                icon: Icon(Icons.shopping_basket),
                label: Text("Акции и предложения"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).pushNamed("/info");
                },
                icon: Icon(Icons.info),
                label: Text("Информация"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      )),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 15,
                backgroundImage:
                    Image.network("https://picsum.photos/id/1027/200/200")
                        .image,
              ),
              accountEmail: Text(
                email,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
              ),
              accountName: Text(
                name,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Профиль',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushNamed("/profile");
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Настройки',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Navigator.of(context).pushNamed("/settings");
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text(
                'Помощь',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Navigator.of(context).pushNamed("/help");
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  leading: Transform.rotate(
                      angle: pi, child: const Icon(Icons.exit_to_app)),
                  title: const Text(
                    'Выйти',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  onTap: () async {
                    final store = StoreProvider.of<AppState>(context);
                    await store.state.auth.signOut();
                    store.dispatch(UpdateUserInfo(null));
                    store.dispatch(UpdateUser(null));
                    store.dispatch(ChangeAuthStatus(AuthStatus.NOT_LOGGED_IN));
                    Navigator.of(context).pushReplacementNamed("/login");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
