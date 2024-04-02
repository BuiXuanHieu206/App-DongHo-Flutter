import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../screens/welcome_screen.dart';

class logoutPage extends StatefulWidget {
  const logoutPage({super.key});

  @override
  State<logoutPage> createState() => _logoutPageState();
}

class _logoutPageState extends State<logoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Thông tin cá nhân",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 460,
            width: 600,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image(
                    image: AssetImage("images/userImg.png"),
                    width: 100,
                    height: 100,
                  ),
                ),
                Container(
                  width: 170,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                      onPressed: (){},
                      child: Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
                Container(
                  width: 170,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                      onPressed: (){},
                      child: Text(
                        'Đổi mật khẩu',
                        style: TextStyle(
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
                Container(
                  width: 170,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () async{
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      Get.offAll(() => WelcomeScreen());
                    },
                    child: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: (index){},
        height: 70,
        color: Color(0xFF4C53A5),
        items: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, "logoutPage");
            },
            icon: Icon(
              Icons.list,
              size: 30,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, "homePage");
            },
            icon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, "cartPage");
            },
            icon: Icon(
              CupertinoIcons.cart_fill,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
