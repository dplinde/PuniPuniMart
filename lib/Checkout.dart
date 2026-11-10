import 'package:flutter/material.dart';

import 'AppStore.dart';
import 'cart_store.dart';

const _checkoutPink = Color(0xFFF29191);
const _checkoutBackground = Color(0xFFCCFBFA);
const _deliveryFee = 50.0;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _recipientController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  String _paymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
    final account = AppStore.instance.currentAccount;
    _recipientController = TextEditingController(text: account?.username ?? '');
    _phoneController = TextEditingController(text: account?.phone ?? '');
    _addressController = TextEditingController(text: account?.address ?? '');
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _currency(double amount) => '₱${amount.toStringAsFixed(2)}';

  Future<void> _placeOrder(CartStore cart) async {
    if (!_formKey.currentState!.validate()) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Place your order?'),
        content: Text(
          'Your total is ${_currency(cart.subtotal + _deliveryFee)} '
          'with $_paymentMethod.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Review order'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _checkoutPink),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    cart.clear();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: _checkoutPink, size: 48),
        title: const Text('Order placed!'),
        content: const Text(
          'Thank you for shopping with PuniPuniCart. Your order is confirmed.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _checkoutPink),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Continue shopping'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  InputDecoration _fieldDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _checkoutPink),
        filled: true,
        fillColor: const Color(0xFFF8FBFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cart = CartStore.instance;

    return Scaffold(
      backgroundColor: _checkoutBackground,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: _checkoutPink,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 68,
                      color: _checkoutPink,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _checkoutPink,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to shopping'),
                    ),
                  ],
                ),
              ),
            );
          }

          final total = cart.subtotal + _deliveryFee;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionCard(
                  title: 'Delivery information',
                  icon: Icons.local_shipping_outlined,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _recipientController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _fieldDecoration(
                          'Recipient name',
                          Icons.person_outline,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter the recipient name.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _fieldDecoration(
                          'Phone number',
                          Icons.phone_outlined,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter a contact phone number.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          'Complete delivery address',
                          Icons.location_on_outlined,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter your complete delivery address.'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _sectionCard(
                  title: 'Payment method',
                  icon: Icons.payment_outlined,
                  child: Material(
                    color: Colors.transparent,
                    child: RadioGroup<String>(
                      groupValue: _paymentMethod,
                      onChanged: (selected) {
                        if (selected != null) {
                          setState(() => _paymentMethod = selected);
                        }
                      },
                      child: Column(
                        children: [
                          _paymentOption(
                            'Cash on Delivery',
                            'Pay when your squishies arrive',
                            Icons.payments_outlined,
                          ),
                          const Divider(height: 1),
                          _paymentOption(
                            'GCash',
                            'Pay via GCash (demo)',
                            Icons.account_balance_wallet_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _sectionCard(
                  title: 'Order summary',
                  icon: Icons.receipt_long_outlined,
                  child: Column(
                    children: [
                      ...cart.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.name}  × ${item.quantity}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_currency(item.total)),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      _summaryLine('Subtotal', _currency(cart.subtotal)),
                      const SizedBox(height: 8),
                      _summaryLine('Delivery', _currency(_deliveryFee)),
                      const Divider(height: 22),
                      _summaryLine('Total', _currency(total), emphasized: true),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: cart,
        builder: (context, _) => cart.items.isEmpty
            ? const SizedBox.shrink()
            : SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              _currency(cart.subtotal + _deliveryFee),
                              style: const TextStyle(
                                color: _checkoutPink,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _checkoutPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () => _placeOrder(cart),
                        icon: const Icon(Icons.check),
                        label: const Text('Place order'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _checkoutPink),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _paymentOption(String value, String subtitle, IconData icon) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      activeColor: _checkoutPink,
      value: value,
      title: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: _checkoutPink),
    );
  }

  Widget _summaryLine(String label, String value, {bool emphasized = false}) {
    final style = TextStyle(
      fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
      fontSize: emphasized ? 17 : 14,
      color: emphasized ? _checkoutPink : Colors.black87,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
