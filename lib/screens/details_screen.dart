import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;
  const DetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 97, 8, 2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sprite comparison row - reduced padding between sprites
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the pair of sprites
                  children: [
                    _buildSpriteColumn(pokemon.spriteUrl, 'Normal'),
                    SizedBox(width: 20), // Reduced from default spacing
                    _buildSpriteColumn(pokemon.shinySpriteUrl, 'Shiny'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                pokemon.name,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: TextStyle(fontSize: 18),
              ),
              _buildInfoSection(title: 'Types', content: pokemon.types.join(', ')),
              _buildInfoSection(title: 'Abilities', content: pokemon.abilities.join(', ')),
              _buildStatsSection(pokemon.stats),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpriteColumn(String imageUrl, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 120, // Slightly reduced from 150
          height: 120, // Slightly reduced from 150
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => 
              Icon(Icons.error, size: 40, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the title and content
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
          SizedBox(height: 4),
          Text(
            content, 
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center, // Center the content text
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, int> stats) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...stats.entries.map((entry) => 
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: entry.value / 200, // Max stat is theoretically 255
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatColor(entry.value),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(entry.value.toString()),
                ],
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  Color _getStatColor(int value) {
    double normalized = value / 200;
    if (normalized > 0.8) return Colors.green;
    if (normalized > 0.6) return Colors.lightGreen;
    if (normalized > 0.4) return Colors.yellow;
    if (normalized > 0.2) return Colors.orange;
    return Colors.red;
  }
}

