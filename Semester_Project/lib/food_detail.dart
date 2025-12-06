import 'package:flutter/material.dart';
import 'food_item.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetailPage({super.key, required this.foodItem});

  // More detailed description based on food item
  String get detailedDescription {
    switch (foodItem.name) {
      case 'Spicy Noodles':
        return 'Authentic Asian-style noodles cooked with fresh vegetables, spicy chili sauce, and a blend of special herbs. Perfectly balanced with crispy tofu and spring onions.';
      case 'Pasta':
        return 'Creamy Alfredo pasta made with premium ingredients, fresh cream, parmesan cheese, and Italian herbs. Served with garlic bread on the side.';
      case 'Chicken Biryani':
        return 'Aromatic basmati rice cooked with tender chicken pieces, saffron, and 15+ authentic spices. Served with raita and salad.';
      case 'Shinwari Karahi':
        return 'Traditional Pashtun-style karahi made with free-range chicken, cooked in authentic spices and served with naan.';
      case 'Beef Pulao':
        return 'Fragrant rice cooked with succulent beef pieces, caramelized onions, and a secret spice blend.';
      case 'Chicken Karahi':
        return 'Spicy and tangy chicken curry cooked in a traditional wok with tomatoes, ginger, garlic, and green chilies.';
      case 'Salad':
        return 'Fresh mix of lettuce, cherry tomatoes, cucumbers, olives, and bell peppers with our signature lemon-olive oil dressing.';
      case 'Donut':
        return 'Soft, fluffy donut glazed with vanilla icing and topped with colorful sprinkles. Freshly baked daily.';
      default:
        return foodItem.des;
    }
  }

  List<String> get ingredients {
    switch (foodItem.name) {
      case 'Spicy Noodles':
        return ['Noodles', 'Bell Peppers', 'Carrots', 'Spring Onions', 'Tofu', 'Soy Sauce', 'Chili Paste'];
      case 'Pasta':
        return ['Pasta', 'Fresh Cream', 'Parmesan Cheese', 'Garlic', 'Butter', 'Italian Herbs'];
      case 'Chicken Biryani':
        return ['Basmati Rice', 'Chicken', 'Onions', 'Yogurt', 'Saffron', 'Biryani Masala'];
      case 'Salad':
        return ['Lettuce', 'Cherry Tomatoes', 'Cucumbers', 'Olives', 'Bell Peppers', 'Lemon Dressing'];
      default:
        return ['Fresh Ingredients', 'Special Spices', 'Love & Care'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    foodItem.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                foodItem.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              centerTitle: true,
            ),
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Rating and Price Row - FIXED OVERFLOW
                  Row(
                    children: [
                      // Rating Section
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star_half, color: Colors.amber, size: 18),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                '4.5 (120)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10),

                      // Price Section - FIXED
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Rs ${foodItem.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Food Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    detailedDescription,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 25),

                  // Ingredients Section
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ingredients.map((ingredient) {
                      return Chip(
                        label: Text(
                          ingredient,
                          style: TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.green[50],
                        side: BorderSide(color: Colors.green[100]!),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 25),

                  // Nutritional Info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nutritional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _nutritionItem('Calories', '450', Icons.local_fire_department),
                            _nutritionItem('Carbs', '65g', Icons.energy_savings_leaf),
                            _nutritionItem('Protein', '25g', Icons.fitness_center),
                            _nutritionItem('Fat', '12g', Icons.water_drop),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  // Preparation Time
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: Colors.blue, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preparation Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Text(
                                '20-30 minutes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delivery_dining, color: Colors.blue[800], size: 18),
                              SizedBox(width: 5),
                              Text(
                                'Free',
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),

      // Add to Cart Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price Display
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Rs ${foodItem.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),

              // Add to Cart Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, foodItem);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nutritionItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.deepOrange, size: 22),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}