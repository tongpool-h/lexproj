import 'package:flutter/material.dart';
import 'package:lexproj/utility/my_constant.dart';
import 'package:lexproj/widgets/show_text.dart';

class ShowButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;

  const ShowButton({
    Key? key,
    required this.label,
    required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: MyConstant.dark),
            ),
            primary: MyConstant.primary,
          ),
          onPressed: pressFunc,
          child: ShowText(
            text: label,
            textStyle: MyConstant().h3WhiteActive(),
          )),
    );
  }
}
