import 'package:flutter/material.dart';
import 'package:password_lock_shared_pre/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_text_style.dart';

class EnterPasswordScreen extends StatefulWidget {
  const EnterPasswordScreen({super.key});

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  String savedPassword = "";

  @override
  void initState() {
    super.initState();
    _loadSavedPassword();
  }

  /// here we create function to get saved password
  Future<void> _loadSavedPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      savedPassword = sharedPreferences.getString("app_password") ?? "";
    });
  }

  /// here we create function to verify the password
  void _verifyPassword() {
    /// if password is match then navigate to home screen
    if (passwordController.text == savedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "please enter password",
            style: myTextStyle18(fontColor: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                "Wrong Password",
                style: myTextStyle21(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Please enter correct password",
                style: myTextStyle18(fontColor: Colors.black45),
              ),
              icon: Image.asset("assets/icons/cross.png", height: 100),
              actions: [
                TextButton(
                  onPressed: () {
                    passwordController.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "re-enter",
                    style: myTextStyle18(fontColor: Colors.blueAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ok",
                    style: myTextStyle18(fontColor: Colors.black45),
                  ),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff405D72),
        actions: [
          // pop menu item
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.question_mark,
                  size: 25,
                  color: Colors.white70,
                ),
                onSelected: (value) {
                  // Handle menu item selection
                  if (value == "forgot") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "we don't recover password",
                          style: myTextStyle18(fontColor: Colors.white54),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "forgot",
                      child: Text("Forgot password", style: myTextStyle18()),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xff405D72),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icons/lock.png", height: 150),

            /// password
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Password",
                    style: myTextStyle18(fontColor: Colors.white54),
                  ),
                  SizedBox(height: 4),
                  TextField(
                    style: myTextStyle21(fontColor: Colors.white),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black54,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xff758694),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 21),

            /// Elevated button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    /// here we perform save password on shared preferences
                    /// here we call _verify password
                    _verifyPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF7E7DC),
                  ),

                  child: Text(
                    "Unlock",
                    style: myTextStyle21(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// THIS IS MY ENTER PASSWORD SCREEN
/// Done
