import 'package:app_dongho/pages/CartPage.dart';
import 'package:app_dongho/pages/Homepage.dart';
import 'package:app_dongho/pages/LogoutPage.dart';
import 'package:app_dongho/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2YF3IdJH6l_QXi1o99cUQNj1bBtkDKBM",
            appId: "1:855756219645:web:810c963dfd3d4ca76aca94",
            messagingSenderId: "855756219645",
            projectId: "app-ban-dongho",
            storageBucket: "app-ban-dongho.appspot.com",
        )
    );
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "/" : (context) => WelcomeScreen(),
        "homePage" : (context) => HomePage(),
        "cartPage" : (context) => CartPage(),
        "logoutPage" : (context) => logoutPage(),
        //"cartPage" : (context) => CartScreen(),
      },
    );
  }
}
