import 'package:car_repair_service/state/state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import 'order_edit.dart';

class OrderInfoPage extends StatefulWidget {
  final Order order;

  OrderInfoPage({this.order});

  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  static final DateFormat dateFormat = DateFormat('dd/LL hh:mm');
  DatabaseReference worksRef;
  DatabaseReference materialsRef;
  List<OrderWork> works = List();
  List<OrderMaterial> materials = List();

  _onWorkAdded(Event event) {
    works.add(OrderWork.fromSnapshot(event.snapshot));
    setState(() {});
  }

  _onWorkChanged(Event event) {
    final old = works.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    works[works.indexOf(old)] = OrderWork.fromSnapshot(event.snapshot);
    setState(() {});
  }

  _onMaterialAdded(Event event) {
    materials.add(OrderMaterial.fromSnapshot(event.snapshot));
    setState(() {});
  }

  _onMaterialChanged(Event event) {
    final old = materials.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    materials[materials.indexOf(old)] =
        OrderMaterial.fromSnapshot(event.snapshot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final user = store.state.user;
    if (worksRef == null) {
      worksRef =
          store.state.db.child("/orders/${user.uid}/${widget.order.key}/works");
      worksRef.onChildAdded.listen(_onWorkAdded);
      worksRef.onChildChanged.listen(_onWorkChanged);
    }
    if (materialsRef == null) {
      materialsRef = store.state.db
          .child("/orders/${user.uid}/${widget.order.key}/materials");
      materialsRef.onChildAdded.listen(_onMaterialAdded);
      materialsRef.onChildChanged.listen(_onMaterialChanged);
    }

    var workSum = 0.0;
    works.forEach((work) {
      workSum += work.price * work.count;
    });
    var materialSum = 0.0;
    materials.forEach((m) {
      materialSum += m.price * m.count;
    });
    bool needToPay = widget.order.status.status != Statuses.Paid &&
        widget.order.status.status != Statuses.Done &&
        materialSum + workSum > 0;

    return Scaffold(
      floatingActionButton: user.email == "test@test.com"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderEditPage(
                          order: widget.order,
                        )));
              },
              child: Icon(
                Icons.plus_one,
                size: 32,
              ),
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Заказ от ${dateFormat.format(widget.order.date)}",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Работы",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                    ),
                    Expanded(
                      flex: 1,
                      child: FirebaseAnimatedList(
                        sort: (DataSnapshot snap1, DataSnapshot snap2) {
                          final work1 = OrderWork.fromSnapshot(snap1);
                          final work2 = OrderWork.fromSnapshot(snap2);
                          final sum1 = work1.price * work1.count;
                          final sum2 = work2.price * work2.count;
                          return sum1.compareTo(sum2);
                        },
                        defaultChild: Text("Загрузка.."),
                        query: worksRef,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          var work = OrderWork.fromSnapshot(snapshot);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: new Text(
                              "${work.name} : ${work.price}*${work.count}=${work.price * work.count}RUB",
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ),
                    workSum != 0
                        ? Text("Сумма: ${workSum}RUB")
                        : SizedBox.shrink(),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Материалы",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                    ),
                    Expanded(
                      flex: 1,
                      child: FirebaseAnimatedList(
                        sort: (DataSnapshot snap1, DataSnapshot snap2) {
                          final material1 = OrderMaterial.fromSnapshot(snap1);
                          final material2 = OrderMaterial.fromSnapshot(snap2);
                          final sum1 = material1.price * material1.count;
                          final sum2 = material2.price * material2.count;
                          return sum1.compareTo(sum2);
                        },
                        defaultChild: Text("Загрузка.."),
                        query: materialsRef,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          final material = OrderMaterial.fromSnapshot(snapshot);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: new Text(
                              "${material.name} : ${material.price}*${material.count}=${material.price * material.count}RUB",
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ),
                    materialSum != 0
                        ? Text("Сумма: ${materialSum}RUB")
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              needToPay
                  ? RaisedButton(
                      onPressed: () {},
                      child: Text("Оплатить ${materialSum + workSum}RUB"),
                      textColor: Colors.white,
                    )
                  : Text("Общая сумма ${materialSum + workSum}RUB"),
            ],
          ),
        ),
      ),
    );
  }
}
