import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';

class ThemeScreen extends StatefulWidget {
  
  final int themeId;
  final String themeName;
  
  const ThemeScreen({
    Key? key, 
    required this.themeId,
    required this.themeName
  }) : super(key: key);
  
  @override
  State<ThemeScreen> createState() => _ThemeScreenState();

}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Center(
        child: Text("[${widget.themeId}] ${widget.themeName}"),
      ),
    );
  }
}
