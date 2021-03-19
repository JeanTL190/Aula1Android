import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            hintStyle: TextStyle(color: Colors.green))),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final _toDoController = TextEditingController();
  TabController _tabController;
  List _toDoList = [[], [], []];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    print(_tabController.index);
    for (int i = 0; i < 3; i++) {
      _readData(i).then((value) {
        setState(() {
          _toDoList[i] = json.decode(value);
        });
      });
    }
    print(_toDoList);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _kTabs = <Tab>[
    Tab(
      icon: Icon(
        Icons.brightness_5,
        color: Colors.white,
      ),
      text: "Diária",
    ),
    Tab(
      icon: Icon(
        Icons.calendar_today_outlined,
        color: Colors.white,
      ),
      text: "Mensal",
    ),
    Tab(
      icon: Icon(
        Icons.laptop_chromebook,
        color: Colors.white,
      ),
      text: "Asimov",
    ),
  ];

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList[_tabController.index].add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList[_tabController.index].sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaTarefas(0),
          _buildListaTarefas(1),
          _buildListaTarefas(2),
        ],
      ),
      bottomNavigationBar: Material(
          color: Colors.green,
          child: TabBar(
            tabs: _kTabs,
            controller: _tabController,
          )),
    );
  }

  Widget _buildListaTarefas(int i) {
    Widget _buildItem(context, index) {
      return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.redAccent[700],
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: CheckboxListTile(
          activeColor: Colors.green,
          title: Text(_toDoList[i][index]["title"]),
          value: _toDoList[i][index]["ok"],
          secondary: CircleAvatar(
              child: Icon(
                _toDoList[i][index]["ok"] ? Icons.check : Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.green),
          onChanged: (c) {
            setState(() {
              _toDoList[i][index]["ok"] = c;
              _saveData();
            });
          },
        ),
        onDismissed: (direction) {
          setState(() {
            _lastRemoved = Map.from(_toDoList[i][index]);
            _lastRemovedPos = index;
            _toDoList[i].removeAt(index);
            _saveData();
            final snack = SnackBar(
              content: Text("Tarefa\"${_lastRemoved["title"]}\" removida!"),
              action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      _toDoList[i].insert(_lastRemovedPos, _lastRemoved);
                      _saveData();
                    });
                  }),
              duration: Duration(seconds: 2),
            );
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(snack);
          });
        },
      );
    }

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: _toDoController,
                decoration: InputDecoration(
                    labelText: "Nova Tarefa",
                    labelStyle: TextStyle(color: Colors.green)),
                cursorColor: Colors.green,
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: RaisedButton(
                    color: Colors.green,
                    child: Text("Add"),
                    textColor: Colors.white,
                    onPressed: _addToDo),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _toDoList[i].length,
              itemBuilder: _buildItem,
            ),
            onRefresh: _refresh,
          ),
        ),
      ],
    );
  }

  Future<File> _getFile(int i) async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return File("${directory.path}/data$i.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList[_tabController.index]);
    final file = await _getFile(_tabController.index);
    return file.writeAsString(data);
  }

  Future<String> _readData(int i) async {
    try {
      final file = await _getFile(i);
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
