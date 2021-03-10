import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _total = 0, _dice1 = 0, _dice2 = 0, _pairWins = 0, _oddWins = 0;
  String _whoWin = "";
  Random _random = Random();
  void _rowDices() {
    setState(() {
      _dice1 = _random.nextInt(6) + 1;
      _dice2 = _random.nextInt(6) + 1;
      _total = _dice1 + _dice2;
      if (_total % 2 == 0) {
        _whoWin = "Pair Won!";
        _pairWins++;
      } else {
        _whoWin = "Odd Won!";
        _oddWins++;
      }
    });
  }

  void _resetGame() {
    setState(() {
      _dice1 = 0;
      _dice2 = 0;
      _total = 0;
      _whoWin = "";
      _pairWins = 0;
      _oddWins = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/dados.jpg",
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Dice1: $_dice1",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Dice2: $_dice2",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            Text(
              "Total: $_total",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: FlatButton(
                child: Text(
                  "Roll the dices!",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
                onPressed: () {
                  _rowDices();
                },
                highlightColor: Colors.red,
                color: Colors.green,
              ),
            ),
            Text(
              _whoWin,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Pair Wins: $_pairWins",
                      style: TextStyle(
                          color: Colors.yellowAccent,
                          backgroundColor: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Odd Wins: $_oddWins",
                      style: TextStyle(
                          color: Colors.yellowAccent,
                          backgroundColor: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: FlatButton(
                child: Text(
                  "Reset Game",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
                onPressed: () {
                  _resetGame();
                },
                highlightColor: Colors.red,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
