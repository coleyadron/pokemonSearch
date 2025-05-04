import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import '../screens/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override 
  void initState() {
    super.initState();
    Provider.of<PokemonProvider>(context, listen: false).fetchPokemons();
  }
}

@override
Widget build(BuildContext context){
  final pokemonProvider = Provider.of<PokemonProvider>(context);
  return Scaffold(
    appBar: AppBar(
      title: Text('Pokédex'),
    ),
    body: pokemonProvider.pokemons.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: pokemonProvider.pokemons.length,
            itemBuilder: (ctx, i) => PokemonCard(
              pokemon: pokemonProvider.pokemons[i],
            ),
        ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),),
      ],
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesScreen(),
            ),
          );
        }
      },
      )
  );
}