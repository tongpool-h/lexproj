import 'package:flutter/material.dart';

import 'package:lexproj/utility/my_constant.dart';

class ShowIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() pressFunc;
  final double? size;

  const ShowIconButton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: pressFunc,
        icon: Icon(
          iconData,
          color: MyConstant.primary,
          size: size ?? 24,
        ));
  }
}
