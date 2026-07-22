import 'package:flutter/material.dart';

import '../../models/cart_model.dart';
import '../../services/cart_service.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  late Future<List<CartModel>> _cartFuture;

  // Primary Theme Colors (Sesuai Desain UI Pink)
  static const Color primaryPink = Color(0xFFFF2A7A);
  static const Color lightPink = Color(0xFFFFF0F5);
  static const Color softPinkBg = Color(0xFFFFEBF1);

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    _cartFuture = _cartService.getCart();
  }

  Future<void> refreshCart() async {
    setState(() {
      loadCart();
    });
  }

  String formatRupiah(int number) {
    final text = number.toString();
    final buffer = StringBuffer();

    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      count++;
      buffer.write(text[i]);

      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return "Rp ${buffer.toString().split('').reversed.join()}";
  }

  Future<void> increaseQty(CartModel cart) async {
    try {
      await _cartService.updateCart(
        cartId: cart.id,
        quantity: cart.quantity + 1,
      );

      await refreshCart();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  Future<void> decreaseQty(CartModel cart) async {
    try {
      if (cart.quantity <= 1) {
        await deleteItem(cart.id);
        return;
      }

      await _cartService.updateCart(
        cartId: cart.id,
        quantity: cart.quantity - 1,
      );

      await refreshCart();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  Future<void> deleteItem(int cartId) async {
    try {
      await _cartService.deleteCart(cartId);

      await refreshCart();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produk dihapus dari keranjang"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Keranjang Saya",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<CartModel>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryPink),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final carts = snapshot.data ?? [];

          if (carts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: lightPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 70,
                      color: primaryPink,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Keranjang masih kosong",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Yuk tambahkan buket favoritmu ❤️",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          int total = 0;
          for (var item in carts) {
            total += item.product.price * item.quantity;
          }

          return RefreshIndicator(
            color: primaryPink,
            onRefresh: refreshCart,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      final subtotal = cart.product.price * cart.quantity;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container Icon/Gambar Produk
                                Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color: lightPink,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.local_florist_rounded,
                                    size: 40,
                                    color: primaryPink,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Informasional Produk
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              cart.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(16),
                                                  ),
                                                  title: const Text("Hapus Produk"),
                                                  content: const Text(
                                                    "Yakin ingin menghapus produk ini dari keranjang?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                      child: const Text("Batal"),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            primaryPink,
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                      child: const Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true) {
                                                deleteItem(cart.id);
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        cart.product.categoryName.isEmpty
                                            ? "Buket Bunga"
                                            : cart.product.categoryName,
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        formatRupiah(cart.product.price),
                                        style: const TextStyle(
                                          color: primaryPink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1, thickness: 0.5),
                            ),
                            // Qty Control & Subtotal Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                    children: [
                                      const TextSpan(text: "Subtotal: "),
                                      TextSpan(
                                        text: formatRupiah(subtotal),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Quantity Control Counter
                                Container(
                                  decoration: BoxDecoration(
                                    color: softPinkBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => decreaseQty(cart),
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: primaryPink,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          "${cart.quantity}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: primaryPink,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => increaseQty(cart),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: primaryPink,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Checkout Container
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Total Pembayaran",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatRupiah(total),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    carts: carts,
                                    total: total,
                                  ),
                                ),
                              );

                              if (result == true) {
                                refreshCart();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryPink,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              "Checkout",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}