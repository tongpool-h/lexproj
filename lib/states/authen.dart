import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lexproj/states/create_account.dart';
import 'package:lexproj/states/my_service.dart';
import 'package:lexproj/utility/my_constant.dart';
import 'package:lexproj/utility/my_dialog.dart';
import 'package:lexproj/widgets/show_button.dart';
import 'package:lexproj/widgets/show_form.dart';
import 'package:lexproj/widgets/show_image.dart';
import 'package:lexproj/widgets/show_text.dart';
import 'package:lexproj/widgets/show_text_button.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool redEye = true;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Container(
            decoration: MyConstant().bgBox(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  newHead(boxConstraints),
                  newCenter(
                    boxConstraints,
                    ShowForm(
                      textInputType: TextInputType.emailAddress,
                      hint: 'Email : ',
                      iconData: Icons.mail_outline,
                      changeFunc: (String string) {
                        email = string.trim();
                      },
                    ),
                  ),
                  newCenter(
                    boxConstraints,
                    ShowForm(
                      redEyeFunc: () {
                        setState(() {
                          redEye = !redEye;
                        });
                      },
                      obsecu: redEye,
                      hint: 'Password :',
                      iconData: Icons.lock_outline,
                      changeFunc: (String string) {
                        password = string.trim();
                      },
                    ),
                  ),
                  newCenter(
                    boxConstraints,
                    ShowButton(
                      label: 'Login',
                      pressFunc: () {
                        if ((email?.isEmpty ?? true) ||
                            (password?.isEmpty ?? true)) {
                          MyDialog(context: context).normalDialog(
                              title: 'Have  Space!',
                              subTitle: 'Please fill every blank');
                        } else {
                          processCheckLogin();
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ShowText(text: 'Non Account?'),
                      ShowTextButton(
                        label: 'Create new account',
                        pressFunc: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CareateAccount(),
                              ));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  SizedBox newCenter(BoxConstraints boxConstraints, Widget widget) {
    return SizedBox(
      width: boxConstraints.maxWidth * 0.6,
      child: widget,
    );
  }

  SizedBox newHead(BoxConstraints boxConstraints) {
    return SizedBox(
      width: boxConstraints.maxWidth * 0.6,
      child: Row(
        children: [
          newLogo(boxConstraints),
          ShowText(
            text: 'Logo : ',
            textStyle: MyConstant().h1Style(),
          ),
        ],
      ),
    );
  }

  Container newLogo(BoxConstraints boxConstraints) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: boxConstraints.maxWidth * 0.15,
        child: const ShowImage(),
      ),
    );
  }

  Future<void> processCheckLogin() async {
    MyDialog(context: context).processDialog();

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      Navigator.pop(context);
      MyDialog(context: context).normalDialog(
          label2: 'My Service',
          pressFunc2: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyService(),
                ),
                (route) => false);
          },
          title: 'Login success!',
          subTitle: 'Welcome to my app, Please tap my service');
    }).catchError((onError) {
      Navigator.pop(context);
      MyDialog(context: context)
          .normalDialog(title: onError.code, subTitle: onError.message);
    });
  }
}
