import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class OrderEditPage extends StatefulWidget {
  final Order order;

  OrderEditPage({this.order});

  @override
  _OrderEditPageState createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  final TextEditingController _materialPrice = TextEditingController();
  final TextEditingController _materialCount = TextEditingController();
  final TextEditingController _materialName = TextEditingController();
  final TextEditingController _workPrice = TextEditingController();
  final TextEditingController _workCount = TextEditingController();
  final TextEditingController _workName = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd/LL hh:mm');

  @override
  void initState() {
    super.initState();
    clearController(_materialName);
    clearController(_materialPrice);
    clearController(_materialCount);
    clearController(_workCount);
    clearController(_workName);
    clearController(_workPrice);
    _workCount.text = "1";
    _materialCount.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Заказ от ${dateFormat.format(widget.order.date)}",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialAddForm(widget.order),
                      Divider(
                        thickness: 3,
                        indent: 15,
                        endIndent: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      WorkAddForm(widget.order),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MaterialAddForm extends StatefulWidget {
  final Order order;

  MaterialAddForm(this.order);

  @override
  MaterialAddFormState createState() => MaterialAddFormState();
}

class MaterialAddFormState extends State<MaterialAddForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _materialPrice = TextEditingController();
  final TextEditingController _materialCount = TextEditingController();
  final TextEditingController _materialName = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearController(_materialName);
    clearController(_materialPrice);
    clearController(_materialCount);
    _materialCount.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final db = store.state.db;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text("Добавить материал"),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните название';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Название",
            ),
            controller: _materialName,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните количество';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Количество",
            ),
            controller: _materialCount,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните цену';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Цена",
            ),
            controller: _materialPrice,
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () async {
              if (!_formKey.currentState.validate()) return;
              final materialName = _materialName.text;
              await db
                  .child(
                      "/orders/${store.state.user.uid}/${widget.order.key}/materials")
                  .push()
                  .set(OrderMaterial(
                          orderID: widget.order.key,
                          price: double.parse(_materialPrice.text),
                          name: materialName,
                          count: int.parse(_materialCount.text))
                      .toJson());
              clearController(_materialName);
              clearController(_materialPrice);
              _materialCount.text = "1";
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text("Материал $materialName добавлен"),
              ));
              setState(() {});
            },
            child: Text("Добавить материал"),
            textColor: Colors.white,
          ),
        ],
      ), // Build this out in the next steps.
    );
  }
}

class WorkAddForm extends StatefulWidget {
  final Order order;

  WorkAddForm(this.order);

  @override
  WorkAddFormState createState() => WorkAddFormState();
}

class WorkAddFormState extends State<WorkAddForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _workPrice = TextEditingController();
  final TextEditingController _workCount = TextEditingController();
  final TextEditingController _workName = TextEditingController();

  @override
  void initState() {
    super.initState();
    clearController(_workName);
    clearController(_workPrice);
    clearController(_workCount);
    _workCount.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final db = store.state.db;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text("Добавить работу"),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните название';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Название",
            ),
            controller: _workName,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните количество';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Количество",
            ),
            controller: _workCount,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Заполните цену';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Цена",
            ),
            controller: _workPrice,
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () async {
              if (!_formKey.currentState.validate()) return;
              final materialName = _workName.text;
              await db
                  .child(
                      "/orders/${store.state.user.uid}/${widget.order.key}/works")
                  .push()
                  .set(OrderMaterial(
                          orderID: widget.order.key,
                          price: double.parse(_workPrice.text),
                          name: materialName,
                          count: int.parse(_workCount.text))
                      .toJson());
              clearController(_workName);
              clearController(_workPrice);
              _workCount.text = "1";
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text("Работа $materialName добавлена"),
              ));
              setState(() {});
            },
            child: Text("Добавить работу"),
            textColor: Colors.white,
          ),
        ],
      ), // Build this out in the next steps.
    );
  }
}
