import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/soundtheme.dart';

class ThemeScreen extends StatefulWidget {
  final List<SoundTheme> themes;

  const ThemeScreen({
    Key? key,
    required this.themes,
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Column(children : [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Padding(padding: EdgeInsets.only(top: 20),
                      child: Text('THEME 1', style: TextStyle(fontSize: 20)))]),
              Expanded(child: Scrollbar(child: Container(margin: const EdgeInsets.all(120.0),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 500,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: 100,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        child:Stack(fit: StackFit.expand,
                            children: [
                              Image.asset('assets/images/image.jpeg', fit: BoxFit.cover), Align(alignment: Alignment.center, child: Text((index + 1).toString(), style: const TextStyle(fontSize: 100, color: Colors.purple)))]),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                            border: Border.all(width: 10)),
                      );
                    }),)))])
          // Text("[${widget.themeId}] ${widget.themeName}"),
        ),
      )
    );
  }
}
