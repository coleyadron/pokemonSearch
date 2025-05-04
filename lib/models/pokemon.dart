class Pokemon {
  final int id;
  final String name;
  final String spriteUrl;
  final String shinySpriteUrl;
  final Map<String, int> stats;
  final List<String> types;
  final List<String> abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.shinySpriteUrl,
    required this.stats,
    required this.types,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final stats = <String, int>{};
    if (json['stats'] != null) {
      for (final stat in json['stats']) {
        final statName = stat['stat']['name'] as String;
        final baseStat = stat['base_stat'] as int;
        stats[statName] = baseStat;
      }
    }

    // Convert types
    final types = <String>[];
    if (json['types'] != null) {
      types.addAll(
        (json['types'] as List).map((type) => type['type']['name'] as String),
      );
    }

    // Convert abilities
    final abilities = <String>[];
    if (json['abilities'] != null) {
      abilities.addAll(
        (json['abilities'] as List).map((ability) => ability['ability']['name'] as String),
      );
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      spriteUrl: json['sprites']['other']['official-artwork']['front_default'],
      shinySpriteUrl: json['sprites']['other']['official-artwork']['front_shiny'],
      stats: stats,
      types: types,
      abilities: abilities,
    );
  }
}