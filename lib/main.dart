import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/widgets/todo-card.dart';
import 'models/item.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var itens = new List<Item>();

  HomePage() {
    this.itens = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() async {
    if (newTaskCtrl.text.isEmpty) return;

    await initializeDateFormatting("pt_BR", null);
    var now = DateTime.now();
    var formatter =
        DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_BR').format(now.toUtc());

    setState(() {
      widget.itens.add(
          Item(title: newTaskCtrl.text, done: false, creationTime: formatter));
      newTaskCtrl.clear();
      save();
    });
  }

  void remove(Item item) {
    setState(() {
      widget.itens.remove(item);
      save();
    });
  }

  Future load() async {
    var preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.itens = result;
      });
    }
  }

  save() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('data', jsonEncode(widget.itens));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextFormField(
          onFieldSubmitted: (value) {
            add();
          },
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
              )),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.itens.length,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.itens[index];
            return TodoCard(
                item: item,
                switchDone: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
                remove: (item) {
                  setState(() {
                    remove(item);
                  });
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
      ),
    );
  }
}
