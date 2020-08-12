import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    final aboutField = new TextField(
      maxLines: 12,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: "Напишите нам",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Помощь',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "https://picsum.photos/id/392/300/200",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 15.0),
                aboutField,
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: () {},
                  textColor: Colors.white,
                  child: Text("Написать"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
