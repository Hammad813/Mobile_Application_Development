import 'package:flutter/material.dart';
import 'package:mid_project/cart.dart';
import 'package:mid_project/profile.dart';
import 'package:mid_project/food_detail.dart';
import 'package:mid_project/services/auth_service.dart';
import 'food_item.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<FoodItem> cart = [];
  int cartCount = 0;

  // Add these variables for user data
  final AuthService _authService = AuthService();
  String userName = 'User';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Add this method to load user data
  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        // First try to get name from Firebase Auth
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          setState(() {
            userName = user.displayName!;
            isLoading = false;
          });
        } else {
          // If not available, get from Firestore
          final userData = await _authService.getUserData(user.uid);
          if (userData != null && userData['name'] != null) {
            setState(() {
              userName = userData['name'];
              isLoading = false;
            });
          } else {
            setState(() {
              userName = 'User';
              isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'User';
        isLoading = false;
      });
    }
  }

  void addToCart(FoodItem item) {
    setState(() {
      cart.add(item);
      cartCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Updated: Show user's name from Firebase
              Text(
                isLoading ? 'Loading...' : 'Hello, $userName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'What you want to eat today?',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/animation/profile.jpg'),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Meals'),
              Tab(text: 'Desserts'),
              Tab(text: 'Snacks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ********* Meals tab me GridView***************
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.57,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                //********************* First food item*******************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Spicy Noodles',
                            des: 'Delicious spicy noodles with extra chili flavor',
                            price: 1000,
                            image: 'assets/animation/noodles.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Spicy Noodles',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Delicious spicy noodles with extra chili flavor',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 1000',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/noodles.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************second food item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Pasta',
                            des: 'Delicious, creamy pasta made with rich sauce',
                            price: 400,
                            image: 'assets/animation/pasta.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Pasta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Delicious, creamy pasta made with rich sauce',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 400',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage('assets/animation/pasta.jpeg')
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Third Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Chicken Biryani',
                            des: 'Chicken Alu Biryani with special spices',
                            price: 300,
                            image: 'assets/animation/biryani.jpg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,  // Changed to max
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Chicken Biryani',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Use Expanded to push price to bottom
                              Expanded(
                                child: Text(
                                  'Chicken Alu Biryani with special spices',  // Longer description
                                  style: TextStyle(color: Colors.grey[700]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Rs 300',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/biryani.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Fourth Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Shinwari Karahi',
                            des: 'Traditional Shinwari-style chicken karahi',
                            price: 3000,
                            image: 'assets/animation/shinwari.jpg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Shinwari Karahi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Traditional Shinwari-style chicken karahi with rich spices',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 3000',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/shinwari.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Fifth Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Beef Pulao',
                            des: 'Beef pulao made with tender meat',
                            price: 550,
                            image: 'assets/animation/pulao.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Beef Pulao',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Beef pulao made with tender meat',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 550',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/pulao.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Sixth Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Chicken Karahi',
                            des: 'Chicken cooked in spicy, karahi masala',
                            price: 2000,
                            image: 'assets/animation/karahi.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Chicken Karahi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Chicken cooked in spicy, karahi masala',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 2000',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage('assets/animation/karahi.jpeg')
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Seventh Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Beef Kabab',
                            des: 'Juicy Beef Kabab',
                            price: 100,
                            image: 'assets/animation/kabab.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Beef Kabab',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Juicy Beef Kabab',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 100',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/kabab.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //*****************************Eighth Food Item*****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Mutton Rice Platter',
                            des: 'Flavorful and aromatic dish featuring tender mutton cooked with rice',
                            price: 2000,
                            image: 'assets/animation/platter.jpg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name - with overflow handling
                              Text(
                                'Mutton Platter',  // Shortened name
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              // Description - with overflow handling
                              Text(
                                'Tender mutton with aromatic rice',  // Shortened description
                                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Rs 2000',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.deepOrange,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: AssetImage('assets/animation/platter.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ********************* Desserts Menu *********************
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // *************** 1. Salad *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Salad',
                            des: 'Fresh green salad with tangy dressing',
                            price: 150,
                            image: 'assets/animation/salad.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Salad',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Fresh green salad with tangy dressing',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 37),
                              Row(
                                children: [
                                  Text(
                                    'RS 150',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/salad.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 2. Cornbread Salad *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Cornbread Salad',
                            des: 'Savory cornbread chunks mixed with veggies',
                            price: 1000,
                            image: 'assets/animation/bread.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Cornbread Salad',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Savory cornbread chunks mixed with veggies',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 1000',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/bread.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 3. Chicken Mango Salad *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Chicken Mango Salad',
                            des: 'Juicy chicken mixed with mango slices and greens',
                            price: 300,
                            image: 'assets/animation/mango.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Chicken Mango Salad',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Juicy chicken mixed with mango slices and greens',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'RS 300',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage:AssetImage('assets/animation/mango.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 4. Grilled Mushrooms *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Grilled Mushrooms',
                            des: 'Smoky grilled mushrooms served with herbs',
                            price: 400,
                            image: 'assets/animation/mashroom.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Grilled Mushrooms',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Smoky grilled mushrooms served with herbs',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'RS 400',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/mashroom.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 5. Pasta Salad *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Pasta Salad',
                            des: 'Pasta tossed with veggies and creamy dressing',
                            price: 600,
                            image: 'assets/animation/pastasalad.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Pasta Salad',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Pasta tossed with veggies and creamy dressing',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 600',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/pastasalad.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 6. Cowboy Butter *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Cowboy Butter',
                            des: 'Garlic butter sauce with herbs and lemon zest',
                            price: 500,
                            image: 'assets/animation/butter.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Cowboy Butter',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Garlic butter sauce with herbs and lemon zest',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    'RS 500',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/butter.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ********************* Snacks menu *********************
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // *************** 1. Melting Potatoes *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Melting Potatoes',
                            des: 'Crispy golden potato chips with light seasoning',
                            price: 200,
                            image: 'assets/animation/alu.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Melting Potatoes',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Crispy golden potato chips with light seasoning',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text(
                                    'RS 200',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/alu.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 2. Samosa *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Samosa',
                            des: 'Crispy fried samosa stuffed with spicy potatoes',
                            price: 50,
                            image: 'assets/animation/samosa.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Samosa',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Crispy fried samosa stuffed with spicy potatoes',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text(
                                    'RS 50',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/samosa.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 3. Spring Roll *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Spring Roll',
                            des: 'Crispy rolls filled with mixed vegetables',
                            price: 100,
                            image: 'assets/animation/roll.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Spring Roll',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Crispy rolls filled with mixed vegetables',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text(
                                    'RS 100',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/roll.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 4. Donut *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'Donut',
                            des: 'Soft glazed donut with sugar coating',
                            price: 150,
                            image: 'assets/animation/donut.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Donut',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Soft glazed donut with sugar coating',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text(
                                    'RS 150',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/donut.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // *************** 5. French Fries *****************
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodItem: FoodItem(
                            name: 'French Fries',
                            des: 'Crispy golden fries served with ketchup',
                            price: 100,
                            image: 'assets/animation/fries.jpeg',
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      addToCart(result as FoodItem);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'French Fries',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Crispy golden fries served with ketchup',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Text(
                                    'RS 100',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/animation/fries.jpeg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom Navigation Items (Home & Account)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Button
                  GestureDetector(
                    onTap: () {
                      // Already on home
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.deepOrange,
                            size: 28,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Spacer for center cart button
                  SizedBox(width: 60),

                  // Account Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 28,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Account',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Center Cart Button (Bigger & Colorful)
              Positioned(
                top: -25,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cart(cartItems: cart),
                          ),
                        );

                        // If checkout was completed, clear cart count
                        if (result == true) {
                          setState(() {
                            cart.clear();
                            cartCount = 0;
                          });
                        }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Cart Icon
                          Center(
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),

                          // Cart Count Badge
                          if (cartCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  '$cartCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}