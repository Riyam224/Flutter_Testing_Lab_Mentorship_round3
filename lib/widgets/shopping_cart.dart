import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // Discount rate (0.0 = no discount, 1.0 = 100% off)

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });
}

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final List<CartItem> _items = [];

  // todo ____________ Fix #1: Prevent adding duplicate items by increasing quantity instead.
  void addItem(String id, String name, double price, {double discount = 0.0}) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        // ✅ Edge case: prevent overflow — quantity cannot exceed 99
        _items[index].quantity = (_items[index].quantity + 1).clamp(1, 99);
      } else {
        _items.add(
          CartItem(id: id, name: name, price: price, discount: discount),
        );
      }
    });
  }

  // todo ____________ Remove a specific item by its ID
  void removeItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  // todo ____________ Update item quantity safely (no negative or excessive values)
  void updateQuantity(String id, int newQuantity) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        // ✅ If quantity becomes 0 or below, remove item entirely
        if (newQuantity <= 0) {
          _items.removeAt(index);
        } else {
          // ✅ Clamp value between 1 and 99 to stay in valid range
          _items[index].quantity = newQuantity.clamp(1, 99);
        }
      }
    });
  }

  // todo ____________ Remove all items from cart
  void clearCart() {
    setState(() {
      _items.clear();
    });
  }

  // todo ____________ Calculate subtotal (price × quantity for all items)
  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // todo ____________ Fix #2: Correct discount calculation + clamp it to subtotal
  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      discount += item.price * item.quantity * item.discount;
    }
    // ✅ Edge case: don’t allow total discount to exceed subtotal
    return discount.clamp(0, subtotal);
  }

  // todo ____________ Fix #3: Correct total amount and handle edge case (discount > subtotal)
  double get totalAmount =>
      (subtotal - totalDiscount).clamp(0, double.infinity);

  // todo ____________ Count total number of items in cart
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    // todo ____________ Wrap everything inside scroll view for overflow safety
    return SingleChildScrollView(
      child: Column(
        children: [
          // todo ____________ Action buttons for adding demo items
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () =>
                    addItem('1', 'Apple iPhone', 999.99, discount: 0.1),
                child: const Text('Add iPhone'),
              ),
              ElevatedButton(
                onPressed: () =>
                    addItem('2', 'Samsung Galaxy', 899.99, discount: 0.15),
                child: const Text('Add Galaxy'),
              ),
              ElevatedButton(
                onPressed: () => addItem('3', 'iPad Pro', 1099.99),
                child: const Text('Add iPad'),
              ),
              ElevatedButton(
                onPressed: () =>
                    addItem('1', 'Apple iPhone', 999.99, discount: 0.1),
                child: const Text('Add iPhone Again'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // todo ____________ Summary section: totals + clear button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Total Items: $totalItems',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: clearCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Clear Cart'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                // ✅ Edge case: show discount as negative visually
                Text('Total Discount: -\$${totalDiscount.toStringAsFixed(2)}'),
                const Divider(),
                Text(
                  'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // todo ____________ Handle empty cart state
          _items.isEmpty
              ? const Center(
                  child: Text(
                    '🛒 Your cart is empty — start adding items!',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final discountedPrice = item.price * (1 - item.discount);
                    final itemTotal = discountedPrice * item.quantity;

                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // todo ____________ Show item details (price + discount)
                            Text(
                              'Price: \$${item.price.toStringAsFixed(2)} each',
                            ),
                            if (item.discount > 0)
                              Text(
                                'Discount: ${(item.discount * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(color: Colors.green),
                              ),
                            Text(
                              // ✅ Edge case: handle 100% discount (free item)
                              item.discount == 1.0
                                  ? 'Item Total: FREE 🎉'
                                  : 'Item Total: \$${itemTotal.toStringAsFixed(2)}',
                            ),
                            // ✅ Edge case: max quantity reached
                            if (item.quantity >= 99)
                              const Text(
                                'Max limit reached (99)',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  updateQuantity(item.id, item.quantity - 1),
                              icon: const Icon(Icons.remove),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('${item.quantity}'),
                            ),
                            IconButton(
                              onPressed: () =>
                                  updateQuantity(item.id, item.quantity + 1),
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () => removeItem(item.id),
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
