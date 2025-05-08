import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonProvider with ChangeNotifier{
  List<Pokemon> _pokemons = [];
  List<int> _favorites = [];
  static const String _favoritesKey = 'favorites';
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  List<Pokemon> get pokemons => _pokemons;
  List<int> get favorites => _favorites;

  Future<void> fetchPokemons() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    //notifyListeners();
    //const String url = 'https://pokeapi.co/api/v2/pokemon?limit=20';

    try {
      _currentPage++;
      final limit = 20;
      final offset = (_currentPage - 1) * limit;
      final url = 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset';
  
      final response = await http.get(Uri.parse(url));
     
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        if (results.isEmpty) {
          _hasMore = false;
          _isLoading = false;
          notifyListeners();
          return;
        }

        final List<Pokemon> loadedPokemons = [];

        for (var result in results) {
          final pokemonResponse = await http.get(Uri.parse(result['url']));
          
          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            final pokemon = Pokemon.fromJson(pokemonData);
            loadedPokemons.add(pokemon);
          } else {
            throw Exception('Failed to load Pokemon data');
          }
        }
        _pokemons.addAll(loadedPokemons);
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load Pokemon list');
      }
    } catch (e) {
      debugPrint('Error fetching Pokemons: $e');
    }
  }

  PokemonProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoriteIds.map(int.parse).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }

    await prefs.setStringList(
      _favoritesKey,
      _favorites.map((id) => id.toString()).toList(),
    );

    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.contains(id);
  }

  set favorites(List<int> favorites) {
    _favorites = favorites;
    notifyListeners();
  }

  Future<Pokemon> getPokemonById(int id) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  Future<List<Pokemon>> searchPokemon(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final localResults = _pokemons.where((pokemon) {
        return pokemon.name.toLowerCase().contains(query.toLowerCase()) ||
               pokemon.id.toString().contains(query);
      }).toList();
      if (localResults.isNotEmpty) {
        return localResults;
      }

      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final List<Pokemon> searchResults = [];

        for (var result in results) {
          final pokemonResponse = await http.get(Uri.parse(result['url']));
          
          if (pokemonResponse.statusCode == 200) {
            final pokemonData = json.decode(pokemonResponse.body);
            final pokemon = Pokemon.fromJson(pokemonData);
            if (pokemon.name.toLowerCase().contains(query.toLowerCase()) ||
                pokemon.id.toString().contains(query)) {
              searchResults.add(pokemon);
            }
          }
        }
        return searchResults;
      } else {
        throw Exception('Failed to load Pokemon list');
      }
    }
    catch (e) {
      debugPrint('Error searching Pokemons: $e');
      return [];
    }
  }
}