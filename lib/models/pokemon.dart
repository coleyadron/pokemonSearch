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
    return Pokemon(
      id: json['id'],
      name: json['name'],
      spriteUrl: json['sprites']['other']['official-artwork']['front_default'],
      shinySpriteUrl: json['sprites']['other']['official-artwork']['front_shiny'],
      stats: Map<String, int>.from(json['stats'].map((stat) => MapEntry(stat['stat']['name'], stat['base_stat']))),
      types: List<String>.from(json['types'].map((type) => type['type']['name'])).toList(),
      abilities: List<String>.from(json['abilities'].map((ability) => ability['ability']['name'])).toList(),
    );
  }
}