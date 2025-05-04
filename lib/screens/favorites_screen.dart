import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    final favoritePokemons = pokemonProvider.pokemons
        .where((pokemon) => pokemonProvider.favorites.contains(pokemon.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}