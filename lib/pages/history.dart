import 'dart:math';

import 'package:car_repair_service/pages/order_info.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DatabaseReference ordersRef;
  final DateFormat dateFormat = DateFormat('dd/LL hh:mm');

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context).state;
    if (ordersRef == null) {
      ordersRef = store.db.child("/orders/${store.user.uid}");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'История',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: FirebaseAnimatedList(
          sort: (DataSnapshot snap1, DataSnapshot snap2) {
            final time1 = snap1.value["timestamp"];
            final time2 = snap2.value["timestamp"];
            if (time1 == time2) {
              return 0;
            }
            if (time1 < time2) {
              return 1;
            }
            return -1;
          },
          defaultChild: Text("Загрузка.."),
          query: ordersRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            final order = Order.fromSnapshot(snapshot);
            return new ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderInfoPage(order: order)));
              },
              leading: Icon(
                order.status.icon(),
                color: order.status.color(),
              ),
              title: Text("Заказ от ${dateFormat.format(order.date)}"),
              subtitle:
                  Text(order.text.substring(0, min(order.text.length, 30))),
            );
          },
        ),
      ),
    );
  }
}
