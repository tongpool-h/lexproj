import 'package:flutter/material.dart';
import 'package:lexproj/utility/my_constant.dart';
import 'package:lexproj/widgets/show_image.dart';
import 'package:lexproj/widgets/show_text.dart';
import 'package:lexproj/widgets/show_text_button.dart';

class MyDialog {
  final BuildContext context;

  MyDialog({
    required this.context,
  });

  Future<void> processDialog() async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<void> normalDialog({
    required String title,
    required String subTitle,
    String? pathImage,
    String? label1,
    String? label2,
    Function()? pressFunc1,
    Function()? pressFunc2,
    Widget? contentWiget,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: SizedBox(
            width: 80,
            child: ShowImage(
              path: pathImage,
            ),
          ),
          title: ShowText(
            text: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(text: subTitle),
        ),
        content: contentWiget ?? const SizedBox(),
        actions: [
          label1 == null
              ? const SizedBox()
              : ShowTextButton(label: label1, pressFunc: pressFunc1!),
          label2 == null
              ? const SizedBox()
              : ShowTextButton(label: label2, pressFunc: pressFunc2!),
          ShowTextButton(
            label: 'Cancle',
            pressFunc: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}// end Class
