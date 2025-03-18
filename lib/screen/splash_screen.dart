import 'package:flutter/material.dart';
import 'package:password_lock_shared_pre/screen/set_password_screen.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enter_password_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Check if password is set and navigate accordingly
  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPassword = prefs.getString("app_password");
    await Future.delayed(const Duration(seconds: 2));
    if (savedPassword == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SetPasswordScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EnterPasswordScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff405D72),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 81),
          Image.asset("assets/icons/folder-security.png" , height: 200,) ,
          SizedBox(height: 16,),
          Text("Folder locker" , style: myTextStyle32(fontColor: Color(
              0xffbeae90) , fontWeight: FontWeight.bold),) ,
          Spacer() ,
          Text("Lock every thing" , style: myTextStyle21(fontColor: Colors.black45),) ,
          SizedBox(
            width: 300,
              child: Divider(color: Colors.white24,)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset("assets/icons/image-.png" , height: 40,) ,
            SizedBox(width: 16,),
            Image.asset("assets/icons/youtube (1).png" , height: 40,) ,
              SizedBox(width: 16,),
            Image.asset("assets/icons/open-folder.png" , height: 40,) ,
              SizedBox(width: 16,),
            Image.asset("assets/icons/music-file.png" , height: 40,) ,

          ],) ,
          SizedBox(height: 51,)

        ],
      ),


    ) ;
  }
}
