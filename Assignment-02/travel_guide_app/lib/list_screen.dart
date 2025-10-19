import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> destinations = [
    {'name': 'Hunza Valley', 'desc': 'Majestic mountains and serene villages.'},
    {'name': 'Skardu', 'desc': 'Gateway to high mountains and lakes.'},
    {'name': 'Lahore', 'desc': 'Historic forts, gardens and rich cuisine.'},
    {'name': 'Islamabad', 'desc': 'Capital city with Margalla Hills.'},
    {'name': 'Karachi', 'desc': 'Coastal city with beaches and markets.'},
    {'name': 'Swat', 'desc': 'Lush valleys and rivers.'},
    {'name': 'Fairy Meadows', 'desc': 'Iconic views of Nanga Parbat.'},
    {'name': 'Murree', 'desc': 'Popular hill station near Islamabad.'},
    {'name': 'Chitral', 'desc': 'Kalash culture and mountain scenery.'},
    {'name': 'Multan', 'desc': 'City of saints, shrines and pottery.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final dest = destinations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF006400),
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(dest['name']!),
            subtitle: Text(dest['desc']!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${dest['name']}')),
              );
            },
          ),
        );
      },
    );
  }
}
