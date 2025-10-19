import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _searchDestination() {
    final text = _destinationController.text.trim();
    final message = text.isEmpty ? 'Please enter a destination' : 'Searching for: $text';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    // For demonstration we only show SnackBar. In a full app, you'd navigate or fetch data.
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner image (network). Replace with local asset if required.
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://www.shutterstock.com/image-vector/pakistan-travel-destination-grand-vector-260nw-1749959039.jpg',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: const Text(
              'Welcome to Pakistan Travel Guide — explore the beauty of Pakistan, from mountains to coastlines.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: 'Discover ',
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 20),
              children: const [
                TextSpan(text: 'Pakistan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                TextSpan(text: ' — Explore culture, history & nature.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Enter destination (e.g., Hunza, Lahore)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _destinationController.clear(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  onPressed: _searchDestination,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('More info will be available soon.')),
                  );
                },
                child: const Text('More Info'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Small features / highlights
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.green),
              title: const Text('Top Highlight'),
              subtitle: const Text('Hunza Valley — mountain views and friendly villages.'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_boat, color: Colors.green),
              title: const Text('Travel Tip'),
              subtitle: const Text('Best time to visit Northern Areas: April to October.'),
            ),
          ),
        ],
      ),
    );
  }
}
