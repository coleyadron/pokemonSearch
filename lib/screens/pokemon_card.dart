import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import '../models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'details_screen.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => DetailScreen(pokemon: pokemon)));
        },
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: pokemon.spriteUrl,
              placeholder: (_, __) => CircularProgressIndicator(),
            ),
            Text('${pokemon.name} #${pokemon.id}'),
            IconButton(
              icon: Icon(
                pokemonProvider.isFavorite(pokemon.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                pokemonProvider.toggleFavorite(pokemon.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}