import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

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
    // itens.add(Item(title: "Fazer Atividade de Eletromagnetismo", done: false));
    // itens.add(Item(title: "Estudar Flutter", done: true));
    // itens.add(Item(title: "Fazer App Todo List", done: true));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.itens.add(Item(title: newTaskCtrl.text, done: false));
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

    if(data != null) {
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
            return Dismissible(
              child: CheckboxListTile(
                value: item.done,
                key: Key(item.title),
                title: Text(item.title),
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              key: Key(item.title),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red.withOpacity(0.4),
              ),
              onDismissed: (direction) {
                remove(item);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
      ),
    );
  }
}
