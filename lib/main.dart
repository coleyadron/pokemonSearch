import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/pokemon_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final favoriteIds = prefs.getStringList('favorites') ?? [];
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider()
        ..favorites = favoriteIds.map(int.parse).toList(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon App',
      home: HomeScreen(),
    );
  }
}
