// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cs442_mp6/api/pokemon_provider.dart';
import 'package:cs442_mp6/models/pokemon.dart';
import 'package:cs442_mp6/screens/details_screen.dart';
import 'package:cs442_mp6/screens/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockPokemonProvider extends Mock implements PokemonProvider {}

void main() {
  final testPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    spriteUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
    shinySpriteUrl: 'bulbasaur_shiny.png',
    stats: {'hp': 45},
    types: ['grass', 'poison'],
    abilities: ['overgrow']
  );

  testWidgets('Toggles favorite status on icon tap', (tester) async {
    final provider = PokemonProvider();
    
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: PokemonCard(pokemon: testPokemon),
        ),
      )
    );

    expect(provider.isFavorite(1), isFalse);
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(provider.isFavorite(1), isTrue);
  });
  testWidgets('Displays favorite icon correctly', (tester) async {
    final provider = PokemonProvider()..toggleFavorite(1);
    
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: PokemonCard(pokemon: testPokemon),
        ),
      )
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Test the details screen navigation', (tester) async {
    final provider = PokemonProvider()..toggleFavorite(1);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: PokemonCard(pokemon: testPokemon),
        ),
      )
    );

    await tester.tap(find.byType(PokemonCard));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
  });

  testWidgets('Test the name and id display', (tester) async {
    final provider = PokemonProvider()..toggleFavorite(1);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: PokemonCard(pokemon: testPokemon),
        ),
      )
    );

    expect(find.text('bulbasaur #1'), findsOneWidget);
  });

  testWidgets('Test the sprite display', (tester) async {
    final provider = PokemonProvider()..toggleFavorite(1);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: PokemonCard(pokemon: testPokemon),
        ),
      )
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}