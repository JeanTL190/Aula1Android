import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController altController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";
  String _idealText = "";
  void _resetField() {
    pesoController.text = "";
    altController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _idealText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcularImc() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double alt = double.parse(altController.text) / 100;
      double imc = peso / (alt * alt);
      double minIdeal = 18.6 * alt * alt - peso;
      double maxIdeal = peso - 24.8 * alt * alt;
      print (peso*1.0-maxIdeal*1.0);
      if (imc < 18.6) {
        _infoText = "Abaixo do Peso! (${imc.toStringAsFixed(2)})";
        _idealText = "Ganhe ${minIdeal.toStringAsFixed(2)}kg para chegar ao peso ideal!";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal! (${imc.toStringAsFixed(2)})";
        _idealText = "Meus parabéns! Mantenha entre ${(peso*1.0+minIdeal*1.0).toStringAsFixed(2)}kg e ${(peso*1.0-maxIdeal*1.0).toStringAsFixed(2)}kg para o peso ideal!";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Levemente Acima do Peso! (${imc.toStringAsFixed(2)})";
        _idealText = "Perca ${maxIdeal.toStringAsFixed(2)}kg para chegar ao peso ideal!";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I! (${imc.toStringAsFixed(2)})";
        _idealText = "Perca ${maxIdeal.toStringAsFixed(2)}kg para chegar ao peso ideal!";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II! (${imc.toStringAsFixed(2)})";
        _idealText = "Perca ${maxIdeal.toStringAsFixed(2)}kg para chegar ao peso ideal!";
      } else if (imc >= 39.9) {
        _infoText = "Obesidade Grau III! (${imc.toStringAsFixed(2)})";
        _idealText = "Perca ${maxIdeal.toStringAsFixed(2)}kg para chegar ao peso ideal!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora IMC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetField),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.blue,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Colors.blue)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
                controller: pesoController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira seu peso!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Colors.blue)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
                controller: altController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira sua altura!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calcularImc();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  _idealText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 25.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
