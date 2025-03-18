import 'package:flutter/material.dart';
import 'package:password_lock_shared_pre/screen/enter_password_screen.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  /// here we create function to save password
  Future<void> _savePassword() async {
    /// her we apply condition if field is empty then show snack message
    if (passwordController.text.isEmpty || confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter both field",
            style: myTextStyle18(fontColor: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (passwordController.text == confirmController.text) {
      /// if password is same then save in shared preferences
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
        "app_password",
        confirmController.text.trim(),
      );

      /// after saving the password navigate to enter password screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EnterPasswordScreen()),
      );
    } else {
      /// else password is not message then show snack message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password do not match",
            style: myTextStyle18(fontColor: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff405D72),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icons/folder-security.png", height: 150),

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
                    cursorColor: Colors.black54,
                    controller: passwordController,
                    keyboardType: TextInputType.number,
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

            /// confirm password
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Confirm Password",
                    style: myTextStyle18(fontColor: Colors.white54),
                  ),
                  SizedBox(height: 4),
                  TextField(
                    style: myTextStyle21(fontColor: Colors.white),
                    obscureText: true,
                    cursorColor: Colors.black54,
                    controller: confirmController,
                    keyboardType: TextInputType.number,
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
                    /// here we call save password function
                    _savePassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF7E7DC),
                  ),

                  child: Text(
                    "Set Password",
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

/// This is my password set screen
/// DONE
