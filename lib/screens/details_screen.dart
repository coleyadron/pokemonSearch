import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DetailScreen extends StatelessWidget{
  final Pokemon pokemon;
  DetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(pokemon.spriteUrl),
            SizedBox(height: 20),
            Text(
              pokemon.name,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}