import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:password_lock_shared_pre/screen/enter_password_screen.dart';
import 'package:password_lock_shared_pre/screen/set_password_screen.dart';
import 'package:password_lock_shared_pre/screen/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Hive.openBox('folderData');
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
