import 'package:cs442_mp6/models/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pokemon Model Tests', () {
    final testJson = {
      'id': 25,
      'name': 'pikachu',
      'sprites': {
        'other': {
          'official-artwork': {
            'front_default': 'pikachu.png',
            'front_shiny': 'pikachu_shiny.png'
          }
        }
      },
      'stats': [
        {'stat': {'name': 'hp'}, 'base_stat': 35},
        {'stat': {'name': 'attack'}, 'base_stat': 55}
      ],
      'types': [
        {'type': {'name': 'electric'}}
      ],
      'abilities': [
        {'ability': {'name': 'static'}}
      ]
    };

    test('Creates Pokemon from JSON correctly', () {
      final pokemon = Pokemon.fromJson(testJson);
      
      expect(pokemon.id, equals(25));
      expect(pokemon.name, equals('pikachu'));
      expect(pokemon.spriteUrl, equals('pikachu.png'));
      expect(pokemon.stats['hp'], equals(35));
      expect(pokemon.types, contains('electric'));
    });

    test('Correctly parses sprite URLs', () {
      final pokemon = Pokemon.fromJson(testJson);
      expect(pokemon.spriteUrl, equals('pikachu.png'));
      expect(pokemon.shinySpriteUrl, equals('pikachu_shiny.png'));
    });

    test('Correctly parses multiple types', () {
      final multiTypeJson = Map<String, dynamic>.from(testJson);
      multiTypeJson['types'].add({'type': {'name': 'flying'}});
      
      final pokemon = Pokemon.fromJson(multiTypeJson);
      expect(pokemon.types.length, equals(2));
    });

    test('Handles empty stats list', () {
      final noStatsJson = Map<String, dynamic>.from(testJson);
      noStatsJson['stats'] = [];
      
      final pokemon = Pokemon.fromJson(noStatsJson);
      expect(pokemon.stats.isEmpty, isTrue);
    });

  test('Correctly parses multiple abilities', () {
    final multiAbilityJson = Map<String, dynamic>.from(testJson);
    multiAbilityJson['abilities'].add({
      'ability': {'name': 'lightning-rod'}
    });
    
    final pokemon = Pokemon.fromJson(multiAbilityJson);
    expect(pokemon.abilities.length, equals(2));
    expect(pokemon.abilities, contains('static'));
    expect(pokemon.abilities, contains('lightning-rod'));
  });
  });
}