import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/pokemon_provider.dart';
import '../screens/pokemon_card.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override 
  void initState() {
    super.initState();
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    provider.fetchPokemons();
    _scrollController.addListener(_onScroll);
  }

  @override 
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<PokemonProvider>(context, listen: false).fetchPokemons();
    }
  }

@override
Widget build(BuildContext context){
  final pokemonProvider = Provider.of<PokemonProvider>(context);
  int _currentIndex = 0;
  return Scaffold(
    appBar: AppBar(
      title: Text('Pokédex', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 97, 8, 2)
    ),
    body: pokemonProvider.pokemons.isEmpty && !pokemonProvider.isLoading
        ? Center(child: CircularProgressIndicator())
        : Column (
          children: [
            Expanded(child:GridView.builder(
            controller: _scrollController,
            gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: pokemonProvider.pokemons.length + (pokemonProvider.hasMore ? 1 : 0),
            itemBuilder: (ctx, i) {
              if (i >= pokemonProvider.pokemons.length) {
                return Center(child: CircularProgressIndicator());
              }
              return PokemonCard(
                pokemon: pokemonProvider.pokemons[i],
              );
            }
            )
            ),
          ]
        ),      
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
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

