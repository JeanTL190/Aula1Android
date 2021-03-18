import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=6b45ecc5";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            hintStyle: TextStyle(color: Colors.amber))),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController()
  ];
  List<String> moedaList = ["Real", "Dólar"];
  List<String> cifraList = ["R\$ ", "US\$ "];

  Map<String, String> mapaSifras = Map();
  double dollar;
  double euro;

  var moedas = [
    DropdownMenuItem(
      child: Text(
        "Real",
        textAlign: TextAlign.center,
      ),
      value: "Real",
    ),
    DropdownMenuItem(
      child: Text(
        "Dólar",
        textAlign: TextAlign.center,
      ),
      value: "Dólar",
    ),
    DropdownMenuItem(
      child: Text(
        "Euro",
        textAlign: TextAlign.center,
      ),
      value: "Euro",
    )
  ];

  void _clearAll() {
    controllers[0].text = "";
    controllers[1].text = "";
  }

  void _func1(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double aux = double.parse(text);
      switch (moedaList[0]) {
        case "Real":
          switch (moedaList[1]) {
            case "Real":
              controllers[1].text = aux.toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[1].text = (aux / dollar).toStringAsFixed(2);
              break;
            case "Euro":
              controllers[1].text = (aux / euro).toStringAsFixed(2);
              break;
          }
          break;
        case "Dólar":
          switch (moedaList[1]) {
            case "Real":
              controllers[1].text = (aux * dollar).toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[1].text = aux.toStringAsFixed(2);
              break;
            case "Euro":
              controllers[1].text = (aux * dollar / euro).toStringAsFixed(2);
              break;
          }
          break;
        case "Euro":
          switch (moedaList[1]) {
            case "Real":
              controllers[1].text = (aux * euro).toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[1].text = (aux * euro / dollar).toStringAsFixed(2);
              break;
            case "Euro":
              controllers[1].text = aux.toStringAsFixed(2);
              break;
          }
          break;
      }
    }
  }

  void _func2(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    } else {
      double aux = double.parse(text);
      switch (moedaList[1]) {
        case "Real":
          switch (moedaList[0]) {
            case "Real":
              controllers[0].text = aux.toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[0].text = (aux / dollar).toStringAsFixed(2);
              break;
            case "Euro":
              controllers[0].text = (aux / euro).toStringAsFixed(2);
              break;
          }
          break;
        case "Dólar":
          switch (moedaList[0]) {
            case "Real":
              controllers[0].text = (aux * dollar).toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[0].text = aux.toStringAsFixed(2);
              break;
            case "Euro":
              controllers[0].text = (aux * dollar / euro).toStringAsFixed(2);
              break;
          }
          break;
        case "Euro":
          switch (moedaList[0]) {
            case "Real":
              controllers[0].text = (aux * euro).toStringAsFixed(2);
              break;
            case "Dólar":
              controllers[0].text = (aux * euro / dollar).toStringAsFixed(2);
              break;
            case "Euro":
              controllers[0].text = aux.toStringAsFixed(2);
              break;
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mapaSifras["Real"] = "R\$ ";
    mapaSifras["Dólar"] = "US\$ ";
    mapaSifras["Euro"] = "€ ";
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text(
          "\$\$ Conversor de Moedas \$\$",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados ...",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar os dados!",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.amber,
                        size: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Converter de:",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: buildDropDownButtom(0),
                      ),
                      Divider(
                        height: 10,
                      ),
                      buildTextField(0, _func1),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Para:",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: buildDropDownButtom(1),
                      ),
                      Divider(
                        height: 10,
                      ),
                      buildTextField(1, _func2),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget buildDropDownButtom(
    int posicao,
  ) {
    return DropdownButton(
      items: moedas,
      onChanged: (tipo) {
        setState(() {
          moedaList[posicao] = tipo;
          cifraList[posicao] = mapaSifras[tipo];
          _clearAll();
        });
      },
      value: moedaList[posicao],
      style: TextStyle(color: Colors.amber, fontSize: 25),
      dropdownColor: Colors.yellow[100],
    );
  }

  Widget buildTextField(int posicao, Function f) {
    return TextField(
      controller: controllers[posicao],
      decoration: InputDecoration(
          labelText: moedaList[posicao],
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: cifraList[posicao]),
      cursorColor: Colors.amber,
      style: TextStyle(color: Colors.amber, fontSize: 25),
      keyboardType: TextInputType.number,
      onChanged: f,
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}
