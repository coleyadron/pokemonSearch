import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import '../models/pokemon.dart';
import 'pokemon_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _searchResults = [];
  bool _isSearching = false;

  void _searchPokemon(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    
    final provider = Provider.of<PokemonProvider>(
      context, 
      listen: false
    );
    
    final results = await provider.searchPokemon(query);
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Pokémon', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 97, 8, 2),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or ID...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchPokemon('');
                      },
                    )
                  : null,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _searchPokemon(value),
            ),
          ),
          if (_isSearching)
            Center(child: CircularProgressIndicator())
          else if (_searchResults.isEmpty)
            Center(
              child: Text(
                _searchController.text.isEmpty
                  ? 'Search for any Pokémon'
                  : 'No results found',
                style: TextStyle(fontSize: 18),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.71,
                ),
                itemCount: _searchResults.length,
                itemBuilder: (ctx, i) => PokemonCard(
                  pokemon: _searchResults[i],
                ),
              ),
            ),
        ],
      ),
    );
  }
}