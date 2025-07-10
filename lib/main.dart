import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _expression = '';
  String _result = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '÷',
    '×',
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '0',
    '.',
    '',
    '',
  ];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        _evaluateExpression();
      } else {
        _expression += buttonText;
      }
    });
  }

  void _evaluateExpression() {
    String finalExpression = _expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    try {
      // ignore: deprecated_member_use
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toString();
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _result,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 40),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.white),
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final text = buttons[index];
                if (text.isEmpty) return SizedBox.shrink();

                Color bgColor =
                    ['+', '-', '×', '÷', '='].contains(text)
                        ? Colors.orange
                        : (text == 'C' || text == 'DEL')
                        ? Colors.red
                        : Colors.grey[850]!;

                return ElevatedButton(
                  onPressed: () => _onButtonPressed(text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(22),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
