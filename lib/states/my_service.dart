import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lexproj/bodys/get_api.dart';
import 'package:lexproj/bodys/get_firebase.dart';
import 'package:lexproj/utility/my_constant.dart';
import 'package:lexproj/utility/my_dialog.dart';
import 'package:lexproj/widgets/show_icon_button.dart';
import 'package:lexproj/widgets/show_text.dart';

class MyService extends StatefulWidget {
  const MyService({Key? key}) : super(key: key);

  @override
  State<MyService> createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  var bodys = <Widget>[];
  var titles = <String>[
    'API',
    'Firebase',
  ];
  var iconDatas = <IconData>[
    Icons.network_check,
    Icons.fire_hydrant,
  ];
  int indexBody = 0;

  var bottomNavigationBarItems = <BottomNavigationBarItem>[];

  String? uidLogin;

  @override
  void initState() {
    super.initState();

    createBottomNavigator();
    findUidLogin();
  }

  Future<void> findUidLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      uidLogin = event!.uid;

      bodys.add(const GetApi());
      bodys.add(GetFirebase(uidLogin: uidLogin!,));
      setState(() {

      });
    });
  }

  void createBottomNavigator() {
    for (var i = 0; i < titles.length; i++) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          label: titles[i],
          icon: Icon(
            iconDatas[i],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: newAppBar(context),
      body: bodys[indexBody],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: MyConstant.primary,
        onTap: (value) {
          setState(() {
            indexBody = value;
          });
        },
        currentIndex: indexBody,
        items: bottomNavigationBarItems,
      ),
    );
  }

  AppBar newAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: ShowText(
        text: titles[indexBody],
        textStyle: MyConstant().h2Style(),
      ),
      actions: [
        ShowIconButton(
          iconData: Icons.exit_to_app,
          pressFunc: () {
            MyDialog(context: context).normalDialog(
                label2: 'SignOut',
                pressFunc2: () {
                  processSignOut(context: context);
                },
                title: 'Sign out ?',
                subTitle: 'Please confirm sign out by tap Signout.');
          },
        ),
      ],
      elevation: 0,
      foregroundColor: MyConstant.dark,
      backgroundColor: Colors.white,
    );
  }

  Future<void> processSignOut({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/authen', (route) => false);
    });
  }
}
