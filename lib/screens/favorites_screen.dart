import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import 'details_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    final favoritePokemons = pokemonProvider.pokemons
        .where((pokemon) => pokemonProvider.favorites.contains(pokemon.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 97, 8, 2),
      ),
      body: favoritePokemons.isEmpty
          ? Center(child: Text('No favorites yet!'))
          : ListView.builder(
              itemCount: favoritePokemons.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: CachedNetworkImage(
                  imageUrl: favoritePokemons[i].spriteUrl,
                  width: 50,
                ),
                title: Text(favoritePokemons[i].name),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      pokemon: favoritePokemons[i],
                    ),
                  ));
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
    ),
    );
  }
}