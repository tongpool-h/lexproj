import 'package:flutter/material.dart';

class MyConstant {
  //Field
  static Color primary = const Color.fromARGB(255, 42, 64, 228);
  static Color dark = const Color.fromARGB(255, 0, 4, 6);
  static Color ligh = const Color.fromARGB(255, 151, 11, 251);
  static Color active = Color.fromRGBO(244, 67, 3, 1);

  //Method
  BoxDecoration bgBox() {
    return BoxDecoration(
      gradient: RadialGradient(
        radius: 0.75,
        center: const Alignment(-0.35, -0.3),
        colors: <Color>[Colors.white, primary],
      ),
    );
  }

  TextStyle h1Style() {
    return TextStyle(
      fontSize: 36,
      color: dark,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style() {
    return TextStyle(
      fontSize: 18,
      color: dark,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle h3Style() {
    return TextStyle(
      fontSize: 14,
      color: dark,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle h3lightStyle() {
    return TextStyle(
      fontSize: 14,
      color: ligh,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle h3ActiveStyle() {
    return TextStyle(
      fontSize: 16,
      color: active,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle h3WhiteActive() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }
} // end Class