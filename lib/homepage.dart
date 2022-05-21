import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: const Center(
        child: Text("Hello World"),
      ),
    );
  }
}
