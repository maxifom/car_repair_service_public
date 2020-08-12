import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool checkbox = false;

  List<String> names = [
    "Уведомления",
    "Заказы",
    "Скидки",
    "Рекламная рассылка",
    "СМС",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[for (var name in names) Switcher(name: name)],
      ),
    );
  }
}

class Switcher extends StatefulWidget {
  final String name;

  Switcher({this.name});

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool checkbox = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => checkbox = !checkbox);
      },
      child: AbsorbPointer(
        child: Container(
          padding: EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.name,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
              ),
              Switch.adaptive(
                onChanged: (s) => {},
                activeColor: Theme.of(context).primaryColor,
                value: checkbox,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
