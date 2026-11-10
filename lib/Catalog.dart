import 'package:flutter/material.dart';

import 'cart_store.dart';

class _SimilarProduct {
  const _SimilarProduct(this.name, this.price, this.image);

  final String name;
  final String price;
  final String image;
}

class CatalogScreen extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productDescription;
  final String productImage;

  const CatalogScreen({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImage,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _quantity = 1;

  static const _products = [
    _SimilarProduct(
      'Small Paw Taba Squishy',
      '₱150.00',
      'assets/images/taba1.jpg',
    ),
    _SimilarProduct('Bear Taba Squishy', '₱160.00', 'assets/images/taba2.webp'),
    _SimilarProduct(
      'Banana Taba Squishy',
      '₱170.00',
      'assets/images/taba3.jpg',
    ),
    _SimilarProduct('Donut Taba Squishy', '₱180.00', 'assets/images/taba4.jpg'),
    _SimilarProduct('Oreo Taba Squishy', '₱190.00', 'assets/images/taba5.jpg'),
    _SimilarProduct(
      'Chocolate Bar Squishy',
      '₱200.00',
      'assets/images/slow1.jpg',
    ),
    _SimilarProduct('Rabit Squishy', '₱210.00', 'assets/images/slow2.jpg'),
    _SimilarProduct('Star Squishy', '₱220.00', 'assets/images/slow3.jpg'),
    _SimilarProduct('Cheese Squishy', '₱230.00', 'assets/images/slow4.jpg'),
    _SimilarProduct('Bread Squishy', '₱240.00', 'assets/images/slow5.jpg'),
  ];

  bool get _isTaba => widget.productImage.contains('taba');
  String get _categoryName => _isTaba ? 'Taba Squishy' : 'Slow Rise';

  List<_SimilarProduct> get _similarProducts => _products
      .where(
        (item) =>
            item.name != widget.productName &&
            item.image.contains(_isTaba ? 'taba' : 'slow'),
      )
      .take(3)
      .toList();

  void _addToCart() {
    CartStore.instance.add(
      name: widget.productName,
      price: widget.productPrice,
      imagePath: widget.productImage,
      quantity: _quantity,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity × ${widget.productName} added to your cart.'),
      ),
    );
  }

  void _openProduct(_SimilarProduct item) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CatalogScreen(
          productName: item.name,
          productPrice: item.price,
          productDescription: item.image.contains('taba')
              ? 'A playful Taba squishy collectible.'
              : 'A slow-rise squishy collectible.',
          productImage: item.image,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.productDescription.trim();
    final displayDescription =
        description.isNotEmpty &&
            description.toLowerCase() != widget.productName.trim().toLowerCase()
        ? description
        : _isTaba
        ? 'A playful Taba squishy collectible.'
        : 'A slow-rise squishy collectible.';

    return Scaffold(
      backgroundColor: const Color(0xFFCCFBFA),
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: const Color(0xFFF29191),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4FAFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          widget.productImage,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_outlined,
                                size: 42,
                                color: Color(0xFFF29191),
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE9E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _categoryName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB64E5A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.productName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          displayDescription,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.productPrice,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFFF29191),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 34,
                                minHeight: 34,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 21,
                              ),
                              color: const Color(0xFFF29191),
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 34,
                                minHeight: 34,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 21,
                              ),
                              color: const Color(0xFFF29191),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF29191),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              'Add to Cart',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Similar Products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF29191),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _similarProducts.map((item) {
                      return Expanded(
                        child: InkWell(
                          onTap: () => _openProduct(item),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFF3DEDE),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const ColoredBox(
                                                color: Color(0xFFF4FAFA),
                                                child: Icon(
                                                  Icons.image_outlined,
                                                  color: Color(0xFFF29191),
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1.1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.price,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFF29191),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
