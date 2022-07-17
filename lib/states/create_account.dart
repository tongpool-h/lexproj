import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexproj/models/user_model.dart';
import 'package:lexproj/utility/my_constant.dart';
import 'package:lexproj/utility/my_dialog.dart';
import 'package:lexproj/widgets/show_button.dart';
import 'package:lexproj/widgets/show_form.dart';
import 'package:lexproj/widgets/show_icon_button.dart';
import 'package:lexproj/widgets/show_image.dart';
import 'package:lexproj/widgets/show_text.dart';

class CareateAccount extends StatefulWidget {
  const CareateAccount({Key? key}) : super(key: key);

  @override
  State<CareateAccount> createState() => _CareateAccountState();
}

class _CareateAccountState extends State<CareateAccount> {
  File? file;
  String? name, email, password, pathImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: ShowText(
          text: 'Create new account',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: ListView(
            children: [
              newImage(boxConstraints, context),
              newCenter(
                boxConstraints: boxConstraints,
                widget: ShowForm(
                  hint: 'Display Name',
                  iconData: Icons.fingerprint,
                  changeFunc: (String string) {
                    name = string.trim();
                  },
                ),
              ),
              newCenter(
                boxConstraints: boxConstraints,
                widget: ShowForm(
                  textInputType: TextInputType.emailAddress,
                  hint: 'Email',
                  iconData: Icons.email_outlined,
                  changeFunc: (String string) {
                    email = string.trim();
                  },
                ),
              ),
              newCenter(
                boxConstraints: boxConstraints,
                widget: ShowForm(
                  hint: 'Password',
                  iconData: Icons.lock_outline,
                  changeFunc: (String string) {
                    password = string.trim();
                  },
                ),
              ),
              newCenter(
                boxConstraints: boxConstraints,
                widget: ShowButton(
                  label: 'Create new account',
                  pressFunc: () {
                    if (file == null) {
                      MyDialog(context: context).normalDialog(
                          title: 'No image',
                          subTitle: 'Please take photo by tap Camera icon');
                    } else if ((name?.isEmpty ?? true) ||
                        (email?.isEmpty ?? true) ||
                        (password?.isEmpty ?? true)) {
                      MyDialog(context: context).normalDialog(
                          title: 'Have Space?',
                          subTitle: 'Please Fill Every blank');
                    } else {
                      processCreateNewAccount();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Row newImage(BoxConstraints boxConstraints, BuildContext context) {
    return newCenter(
      edgeInsetsGeometry: const EdgeInsets.symmetric(vertical: 16),
      boxConstraints: boxConstraints,
      widget: SizedBox(
        width: boxConstraints.maxWidth * 0.6,
        height: boxConstraints.maxWidth * 0.6,
        child: Stack(
          children: [
            file == null
                ? const ShowImage(
                    path: 'images/image.png',
                  )
                : CircleAvatar(
                    radius: boxConstraints.maxWidth * 0.3,
                    backgroundImage: FileImage(file!),
                  ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ShowIconButton(
                size: 36,
                iconData: Icons.add_a_photo,
                pressFunc: () {
                  MyDialog(context: context).normalDialog(
                      label1: 'Camera',
                      pressFunc1: () {
                        Navigator.pop(context);
                        processTakePhoto(source: ImageSource.camera);
                      },
                      label2: 'Gallery',
                      pressFunc2: () {
                        Navigator.pop(context);
                        processTakePhoto(source: ImageSource.gallery);
                      },
                      pathImage: 'images/image.png',
                      title: 'Source Image ?',
                      subTitle: 'Please Tap Camera or Gallery');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Row newCenter(
      {required BoxConstraints boxConstraints,
      required Widget widget,
      EdgeInsetsGeometry? edgeInsetsGeometry}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: edgeInsetsGeometry,
          width: boxConstraints.maxWidth * 0.6,
          child: widget,
        ),
      ],
    );
  }

  Future<void> processTakePhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (result != null) {
      file = File(result.path);
      setState(() {});
    }
  }

  Future<void> processCreateNewAccount() async {
    MyDialog(context: context).processDialog();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;
      print('Create new account success uid==>>$uid');

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('image/$uid.jpg');
      UploadTask uploadTask = reference.putFile(file!);
      await uploadTask.whenComplete(() async {
        await reference.getDownloadURL().then((value) async {
          String pathImage = value;
          print('UploadTask complete pathImage ==>> $pathImage');

          UserModel userModel = UserModel(
              name: name!,
              email: email!,
              password: password!,
              pathImage: pathImage);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(userModel.toMap())
              .then((value) {
                
            Navigator.pop(context);

            MyDialog(context: context).normalDialog(
                label2: 'Authen',
                pressFunc2: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                title: 'Create account success!',
                subTitle: 'Welcome to app, Please Authen');
          });
        });
      });
    }).catchError((error) {
      Navigator.pop(context);

      MyDialog(context: context)
          .normalDialog(title: error.code, subTitle: error.message);
    });
  }
}
