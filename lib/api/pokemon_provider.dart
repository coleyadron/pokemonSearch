import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonProvider with ChangeNotifier{
  List<Pokemon> _pokemons = [];
  List<int> _favorites = [];

  List<Pokemon> get pokemons => _pokemons;
  List<int> get favourites => _favorites;

  Future<void> fetchPokemons() async {
    const String url = 'https://pokeapi.co/api/v2/pokemon?limit=20';
    try {
      final response = await http.get(Uri.parse(url));
     
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        for (var result in results) {
          final pokemonResponse = await http.get(Uri.parse(result['url']));
          
          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            final pokemon = Pokemon.fromJson(pokemonData);
            _pokemons.add(pokemon);
          } else {
            throw Exception('Failed to load Pokemon data');
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load Pokemon list');
      }
    } catch (e) {
      debugPrint('Error fetching Pokemons: $e');
    }
  }

  Future<void> toggleFavorite(int id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.contains(id);
  }


}