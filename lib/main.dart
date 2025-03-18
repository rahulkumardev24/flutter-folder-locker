import 'package:flutter/material.dart';
import 'package:password_lock_shared_pre/screen/enter_password_screen.dart';
import 'package:password_lock_shared_pre/screen/set_password_screen.dart';
import 'package:password_lock_shared_pre/screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? savedPassword = sharedPreferences.getString("app_password");
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

/// IN THIS VIDEO
/// We lock and unlock Flutter application with shared preferences
/// Simple Steps and code
/// Step 1 => DONE
/// add Dependency
/// Step 2 => DONE
/// Project Setup
/// Step 3 => DONE
/// password set screen
/// Step 4 => DONE
/// password enter screen
/// Step 5 => DONE
/// show screen according to user password set or not , if user is password is set the show enter password screen , else set password screen show
/// Step 6
/// final test
///
