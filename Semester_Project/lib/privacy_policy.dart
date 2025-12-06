import 'package:flutter/material.dart';

class SimplePrivacyPolicy extends StatelessWidget {
  const SimplePrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Center(
              child: Text(
                'FOODDELIGHT PRIVACY POLICY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              'Last Updated: December 5, 2023',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Section 1
            _buildSection('1. Information We Collect', '''
We collect the following information when you use our app:
- Name and contact details
- Delivery address
- Order history
- Payment information (processed securely)
- Device information for app functionality
'''),

            const SizedBox(height: 25),

            // Section 2
            _buildSection('2. How We Use Your Information', '''
Your information is used for:
- Processing your food orders
- Delivering orders to your address
- Customer support
- Improving our services
- Sending order updates (if you opt-in)
'''),

            const SizedBox(height: 25),

            // Section 3
            _buildSection('3. Data Sharing', '''
We may share your information with:
- Restaurants to prepare your orders
- Delivery partners for order delivery
- Payment processors for transactions
- Legal authorities if required by law

We do NOT sell your personal data.
'''),

            const SizedBox(height: 25),

            // Section 4
            _buildSection('4. Data Security', '''
We take reasonable measures to protect your data:
- Secure payment processing
- Encrypted data transmission
- Limited access to personal information
- Regular security updates
'''),

            const SizedBox(height: 25),

            // Section 5
            _buildSection('5. Your Rights', '''
You have the right to:
- Access your personal data
- Correct inaccurate information
- Delete your account
- Opt-out of marketing emails
- Export your data
'''),

            const SizedBox(height: 25),

            // Section 6
            _buildSection('6. Contact Us', '''
For privacy-related questions:
Email: privacy@fooddelight.com
Phone: +92 300 123 4567

Address: FoodDelight HQ, Karachi, Pakistan
'''),

            const SizedBox(height: 25),

            // Section 7
            _buildSection('7. Policy Changes', '''
We may update this policy periodically. 
Continued use of our app means you accept 
the updated policy.
'''),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'By using FoodDelight app, you agree to this Privacy Policy.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Simple back button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}