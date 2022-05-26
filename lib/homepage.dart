import 'package:flutter/material.dart';
import 'package:musiconator/main.dart';
import 'package:musiconator/soundtheme.dart';

class Homepage extends StatefulWidget {
  final List<SoundTheme> themes;

  const Homepage({
    Key? key,
    required this.themes,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
    
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: Padding(
        padding : const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: widget.themes.length ,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text( "theme "+ index.toString() + " : " + widget.themes[index].name ),
              onTap: () => {}, //ajouter la fonction pour aller dans un th�me 
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                icon:const Icon(Icons.edit),
                onPressed: () { },
                
                ), 
              ]
              )
            );
          },
        ),
        
      ),
      floatingActionButton: FloatingActionButton.extended(  
        icon : const Icon(Icons.add),
        label: const Text('Theme'),
        backgroundColor: Colors.blue,  
        foregroundColor: Colors.white,  
        onPressed: () => {
          widget.themes.add(
            SoundTheme(id: -1, name: "explosion")//ajouter la modal pour cr�er un th�me
          )
        },  
      ),  
    );
  }
}
