import 'package:car_repair_service/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Запись на обслуживание',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: OrderForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderForm extends StatefulWidget {
  @override
  OrderFormState createState() => OrderFormState();
}

class OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _time = new TextEditingController();
  TextEditingController _text = new TextEditingController();
  DateFormat dateFormat = new DateFormat('E, dd LLLL');
  DateFormat timeFormat = new DateFormat.Hm();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 60)),
      locale: const Locale("ru"),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: dateFormat.format(picked));
      });
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedTime)
      setState(() {
        selectedTime = pickedS;
        var now = DateTime.now();
        _time.value = TextEditingValue(
            text: timeFormat.format(DateTime(now.year, now.month, now.day,
                selectedTime.hour, selectedTime.minute)));
      });
  }

  @override
  Widget build(BuildContext context) {
    final dateField = GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Заполните дату';
            }
            return null;
          },
          style: this.style,
          controller: _date,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Дата",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0))),
        ),
      ),
    );
    final timeField = GestureDetector(
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Заполните время';
            }
            return null;
          },
          style: this.style,
          controller: _time,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Время",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0))),
        ),
      ),
    );
    final aboutField = new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Заполните поле';
        }
        return null;
      },
      style: this.style,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      controller: _text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Что делаем?",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
    );
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            "https://picsum.photos/id/392/300/200",
            fit: BoxFit.contain,
          ),
          SizedBox(height: 35.0),
          dateField,
          SizedBox(height: 15.0),
          timeField,
          SizedBox(height: 15.0),
          aboutField,
          SizedBox(height: 15.0),
          RaisedButton(
            onPressed: () async {
              final store = StoreProvider.of<AppState>(context).state;
              if (!_formKey.currentState.validate()) return;
              final db = store.db;
              final date = DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedTime.minute);
              final order =
                  Order(userID: store.user.uid, date: date, text: _text.text);
              await db
                  .child("/orders/${store.user.uid}")
                  .push()
                  .set(order.toJson());
              Navigator.of(context).pushNamed("/history");
            },
            textColor: Colors.white,
            child: Text("Записаться"),
          ),
        ],
      ), // Build this out in the next steps.
    );
  }
}
