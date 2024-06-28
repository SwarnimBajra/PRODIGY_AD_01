import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

// Constants for app colors
class AppColors {
  static const primaryColor = Color(0xFF212224);
  static const secondaryColor = Color(0xFF317AF7);
  static const secondary2Color = Color(0xFF26282D);
}

// Provider class to manage calculator state
class CalculatorProvider with ChangeNotifier {
  final TextEditingController compController = TextEditingController();
  String _expression = '';

  // Method to update calculator value based on button press
  void setValue(String value) {
    if (value == 'AC') {
      compController.clear();
      _expression = '';
    } else if (value == 'C') {
      if (compController.text.isNotEmpty) {
        compController.text =
            compController.text.substring(0, compController.text.length - 1);
        _expression = _expression.substring(0, _expression.length - 1);
      }
    } else if (value == '=') {
      try {
        var evalExpr = _expression.replaceAll('X', '*');
        var result = _evaluate(evalExpr);
        compController.text = result.toString();
        _expression = '$evalExpr = $result';
      } catch (e) {
        compController.text = 'Error';
        _expression = '';
      }
    } else {
      compController.text += value;
      _expression += value;
    }
    notifyListeners();
  }

  // Method to evaluate mathematical expression
  double _evaluate(String expression) {
    try {
      // Using dart:math to evaluate the expression
      expression = expression.replaceAll('X', '*');

      // Creating a RegExp to match mathematical operators
      RegExp numRegExp = RegExp(r'\d+(\.\d+)?');
      RegExp opRegExp = RegExp(r'[\+\-\*\/%]');

      // Splitting the expression into numbers and operators
      List<String> numbers =
          numRegExp.allMatches(expression).map((m) => m.group(0)!).toList();
      List<String> ops =
          opRegExp.allMatches(expression).map((m) => m.group(0)!).toList();

      // Initializing result with the first number
      double result = double.parse(numbers[0]);

      // Performing operations
      for (int i = 0; i < ops.length; i++) {
        double nextNumber = double.parse(numbers[i + 1]);
        switch (ops[i]) {
          case '+':
            result += nextNumber;
            break;
          case '-':
            result -= nextNumber;
            break;
          case '*':
            result *= nextNumber;
            break;
          case '/':
            if (nextNumber == 0) {
              throw Exception('Division by zero');
            }
            result /= nextNumber;
            break;
          case '%':
            result %= nextNumber;
            break;
          default:
            throw Exception('Invalid operator');
        }
      }
      return result;
    } catch (e) {
      // Handle errors, e.g., division by zero or invalid expressions
      throw Exception('Error evaluating expression: $e');
    }
  }
}

// Widget for custom text field
class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          fillColor: AppColors.primaryColor,
          filled: true,
        ),
        style: const TextStyle(fontSize: 50),
        readOnly: true,
        autofocus: true,
        showCursor: true,
      ),
    );
  }
}

// Stateful widget for individual calculator buttons
class Button1 extends StatefulWidget {
  const Button1({Key? key, required this.label, this.textColor = Colors.white})
      : super(key: key);

  final String label;
  final Color textColor;

  @override
  _Button1State createState() => _Button1State();
}

class _Button1State extends State<Button1> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () => Provider.of<CalculatorProvider>(context, listen: false)
          .setValue(widget.label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: _pressed ? 68 : 72,
        width: _pressed ? 68 : 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondaryColor, AppColors.secondary2Color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: CircleAvatar(
          radius: 36,
          backgroundColor: Colors.transparent,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for the "=" button
class CalculateButton extends StatelessWidget {
  const CalculateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Provider.of<CalculatorProvider>(context, listen: false).setValue("="),
      child: Container(
        height: 160,
        width: 70,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(
          child: Text(
            "=",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}

// List of all calculator buttons
List<Widget> buttonList = [
  const Button1(label: "AC", textColor: AppColors.secondaryColor),
  const Button1(label: "C", textColor: AppColors.secondaryColor),
  const Button1(label: "%"),
  const Button1(label: "/"),
  const Button1(label: "7"),
  const Button1(label: "8"),
  const Button1(label: "9"),
  const Button1(label: "X", textColor: AppColors.secondaryColor),
  const Button1(label: "4"),
  const Button1(label: "5"),
  const Button1(label: "6"),
  const Button1(label: "-"),
  const Button1(label: "1"),
  const Button1(label: "2"),
  const Button1(label: "3"),
  const Button1(label: "+", textColor: AppColors.secondaryColor),
  const Button1(label: "0"),
  const Button1(label: "."),
  const CalculateButton(),
];

// Home screen widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text("Calculator App"),
            backgroundColor: Colors.black,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: provider.compController,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Rows of buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < 4; i++)
                            Expanded(child: buttonList[i]),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 4; i < 8; i++)
                            Expanded(child: buttonList[i]),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 8; i < 12; i++)
                            Expanded(child: buttonList[i]),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 12; i < 15; i++)
                            Expanded(child: buttonList[i]),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 15; i < buttonList.length; i++)
                            Expanded(child: buttonList[i]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Main function to run the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalculatorProvider(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    ),
  );
}
