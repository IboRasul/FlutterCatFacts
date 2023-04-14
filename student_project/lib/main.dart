import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const catFacts());
}

class Fact{
  String fact;
  int factLength;
  Fact({required this.fact,required this.factLength});

  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(
      fact: json['fact'],
      factLength: json['length'],
    );
  }

}

Future<Fact> fetchCat() async{
  final url='https://catfact.ninja/fact';
  final response= await get(Uri.parse(url));
  print(response.body);
  if(response.statusCode==200){
    final jsonResponse= json.decode(response.body);
    print(jsonResponse);
    return Fact.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to fetch cat fact');
  }
}



class catFacts extends StatefulWidget {
  const catFacts({Key? key}) : super(key: key);

  @override
  State<catFacts> createState() => _catFactsState();
}

class _catFactsState extends State<catFacts> {
  Fact? _fact;

  Future<void> _updateScreen() async{
    final fact= await fetchCat();
    setState(() {
      _fact = fact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Cat Fact App',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(style: TextStyle(color: Colors.deepPurpleAccent),"Ninja Cat App!"),
          titleTextStyle: TextStyle(color: Colors.black , fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/6142f7ea-475e-4d5d-af0d-4085272f9901/ddxvb0p-bb09dbed-3dcd-409e-8227-94027285422d.png"),
                    fit: BoxFit.cover
                )
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage( 'https://t3.ftcdn.net/jpg/05/68/86/08/240_F_568860864_GKzRB0pZ2eDkPvXapaSiO5p5TEYSjvVl.jpg' ),
                ),
              ),
              SizedBox.fromSize(size: Size.fromHeight(30)),
              ElevatedButton(
                onPressed: () => _updateScreen(),
                child: const Text('Random Cat Fact'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(fontSize: 18 ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              if (_fact != null) ...[
                const SizedBox(height: 20),

                Container(
                  width: 600, height: 175,
                  child: Text(
                    _fact!.fact,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold , color: Colors.purple),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(),
                Text(
                  'Amount of Characters : ${_fact!.factLength}',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                )
              ],
            ],
          ),
        ),
      ),

    );
  }
}
