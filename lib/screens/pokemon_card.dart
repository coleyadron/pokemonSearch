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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => DetailScreen(pokemon: pokemon)));
        },
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 150, // Adjust height as needed
                  child: CachedNetworkImage(
                    imageUrl: pokemon.spriteUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => CircularProgressIndicator(),
                  ),
                ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${pokemon.name} #${pokemon.id}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return IconButton(
                        padding: EdgeInsets.zero, 
                        iconSize: constraints.maxWidth * 0.15,
                        icon: Icon(
                          pokemonProvider.isFavorite(pokemon.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                              color: Colors.red[400],
                        ),
                        onPressed: () {
                          pokemonProvider.toggleFavorite(pokemon.id);
                        },
                      );
                    },
                  ),
                ],
              )
            ),
          ],
        ),
        ), 
      ),
    );
  }
}