import 'package:flutter/material.dart'; // Material Library

import 'Cart.dart';
import 'Catalog.dart';
import 'Checkout.dart';
import 'UserAcct.dart';

// ==================== PRODUCT MODEL ====================
class ProductItem {
  final String name;
  final String price;
  final String imagePath;

  ProductItem({
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

// ==================== HOME SCREEN (Home.dart) ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Taba Squishies
  final List<ProductItem> _allTabaProducts = [
    ProductItem(
      name: 'Small Paw Taba Squishy',
      price: '₱150.00',
      imagePath: 'assets/images/taba1.jpg',
    ),
    ProductItem(
      name: 'Bear Taba Squishy',
      price: '₱160.00',
      imagePath: 'assets/images/taba2.webp',
    ),
    ProductItem(
      name: 'Banana Taba Squishy',
      price: '₱170.00',
      imagePath: 'assets/images/taba3.jpg',
    ),
    ProductItem(
      name: 'Donut Taba Squishy',
      price: '₱180.00',
      imagePath: 'assets/images/taba4.jpg',
    ),
    ProductItem(
      name: 'Oreo Taba Squishy',
      price: '₱190.00',
      imagePath: 'assets/images/taba5.jpg',
    ),
  ];

  // Slow Squishies
  final List<ProductItem> _allSlowProducts = [
    ProductItem(
      name: 'Chocolate Bar Squishy',
      price: '₱200.00',
      imagePath: 'assets/images/slow1.jpg',
    ),
    ProductItem(
      name: 'Rabit Squishy',
      price: '₱210.00',
      imagePath: 'assets/images/slow2.jpg',
    ),
    ProductItem(
      name: 'Star Squishy',
      price: '₱220.00',
      imagePath: 'assets/images/slow3.jpg',
    ),
    ProductItem(
      name: 'Cheese Squishy',
      price: '₱230.00',
      imagePath: 'assets/images/slow4.jpg',
    ),
    ProductItem(
      name: 'Bread Squishy',
      price: '₱240.00',
      imagePath: 'assets/images/slow5.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Search bar filtering
    final filteredTabaProducts = _allTabaProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final filteredSlowProducts = _allSlowProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFCCFBFA), // Pastel Cyan background
      // ==================== APPBAR ====================
      appBar: AppBar(
        title: const Text('PuniPuniCart'),
        backgroundColor: const Color(0xFFF29191), // Palette color
        foregroundColor: Colors.white,
        actions: [
          // Cart Navigation
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          // Payment / Checkout Navigation
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            },
          ),
          // User Account Navigation
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAcctScreen()),
              );
            },
          ),
        ],
      ),

      // ==================== VERTICAL SCROLL AS A WHOLE ====================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/punipuni_banner.png',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, 0.3),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ==================== SEARCH BAR ====================
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search squishies...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFF29191)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),

            // 1. TABA SQUISHY CATEGORY (Horizontal Scroll)
            if (filteredTabaProducts.isNotEmpty)
              _buildCategorySection(
                'Taba Squishy Category',
                filteredTabaProducts,
              ),

            if (filteredTabaProducts.isNotEmpty &&
                filteredSlowProducts.isNotEmpty)
              const SizedBox(height: 25),

            // 2. SLOW SQUISHY CATEGORY (Horizontal Scroll)
            if (filteredSlowProducts.isNotEmpty)
              _buildCategorySection(
                'Slow Rise Squishy Category',
                filteredSlowProducts,
              ),

            // Kung walang nahanap
            if (filteredTabaProducts.isEmpty && filteredSlowProducts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'No squishies found!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Reusable widget para sa bawat category na may sariling horizontal scroll
  Widget _buildCategorySection(String title, List<ProductItem> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ADAD),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          //size box for the size of the product
          height: 210, // Saktong taas ng card
          child: ListView.builder(
            // listview widget for horizontal scroll
            scrollDirection: Axis.horizontal, // Pahalang na swipe para sa items
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    // ==================== INDIVIDUAL PRODUCT CLICK ====================
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatalogScreen(
                            productName: product.name,
                            productPrice: product.price,
                            productDescription: product.name,
                            productImage: product.imagePath,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // images
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Container(
                              color: const Color(0xFFB1E5E6),
                              width: double.infinity,
                              child: Image.asset(
                                product.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // name and price
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.price,
                                style: const TextStyle(
                                  color: Color(0xFFF29191),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
