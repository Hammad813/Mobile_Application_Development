import 'package:flutter/material.dart';
import 'food_item.dart';

class Cart extends StatefulWidget {
  final List<FoodItem> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = List.generate(widget.cartItems.length, (index) => 1);
  }

  void _removeItem(int index) {
    setState(() {
      quantities.removeAt(index);
      widget.cartItems.removeAt(index);
    });
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (int i = 0; i < widget.cartItems.length; i++) {
      subtotal += widget.cartItems[i].price * quantities[i];
    }
    return subtotal;
  }

  double _calculateTax() {
    return _calculateSubtotal() * 0.10;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateTax();
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Items: ${widget.cartItems.length}'),
            Text('Subtotal: Rs ${_calculateSubtotal().toStringAsFixed(0)}'),
            Text('Tax (10%): Rs ${_calculateTax().toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Text(
              'Total: Rs ${_calculateTotal().toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showOrderConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Order Confirmed!'),
          ],
        ),
        content: const Text('Your order has been placed successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Clear cart
              setState(() {
                widget.cartItems.clear();
                quantities.clear();
              });

              // Close dialog
              Navigator.pop(context);

              // Go back to FirstPage with result to clear cart count
              Navigator.pop(context, true);  // true means cart was cleared
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 128.0),
          child: const Text('Order Details'),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty 😕',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                final quantity = quantities[index];

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 40, bottom: 20),
                      height: 185,
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 100, top: 15),
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 90),
                                  child: Text(
                                    item.des,
                                    style:
                                    const TextStyle(fontSize: 10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 30),
                                        child: Text(
                                          'Rs ${(item.price * quantity).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      QuantityController(
                                        quantity: quantity,
                                        onIncrement: () {
                                          setState(() {
                                            quantities[index]++;
                                          });
                                        },
                                        onDecrement: () {
                                          setState(() {
                                            if (quantities[index] > 1) {
                                              quantities[index]--;
                                            } else {
                                              _removeItem(index);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 25,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(item.image),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Bill Summary and Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bill Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Rs ${_calculateSubtotal().toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax (10%)',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Rs ${_calculateTax().toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rs ${_calculateTotal().toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showCheckoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityController extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityController({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Number above
        Text(
          '$quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: quantity == 0 ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onDecrement,
                child: const Icon(Icons.remove, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onIncrement,
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ],
    );
  }
}