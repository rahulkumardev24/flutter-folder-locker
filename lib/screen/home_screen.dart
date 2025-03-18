import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Folder locker")),
      body: GridView.builder(
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 11,
          mainAxisSpacing: 11,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "https://i.pinimg.com/736x/ef/3b/8b/ef3b8b7f51b54bb8a9b3077dd63543c4.jpg",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
