import 'package:flutter/material.dart';

class BonusPage extends StatefulWidget {
  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Бонусная программа',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, height: 1.5),
                      children: <TextSpan>[
                        TextSpan(
                            text: "ЧТО:\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "Копите баллы и получайте бонусы в программе лояльности MazdaPro.\n"),
                        TextSpan(
                            text: "Как копить баллы?\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "Совершайте покупки и сканируйте карту лояльности. Вы также можете заработать 1000 баллов, заполнив свой профиль участника программы полностью единовременно.\n"),
                        TextSpan(
                            text: "Как получать бонусы?\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "За каждые заработанные 6000 баллов вы получаете бонус на следующую покупку. Пожалуйста, обратите внимание, что бонусы появляются в вашем аккаунте через 30 дней после накопления 6000 баллов.\n"),
                        TextSpan(
                            text: "Как долго действует мой бонус?\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "Бонус действует в течение 6 месяцев.\n"),
                        TextSpan(
                            text: "Все покупки дают баллы?\n",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "Да, все приобретенные товары будут давать вам баллы за исключением приобретения подарочных карт и благотворительных товаров.\n"),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
