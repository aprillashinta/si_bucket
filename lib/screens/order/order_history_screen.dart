import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/order_model.dart';
import '../../services/order_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();

  late Future<List<OrderModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _orderService.getOrders();
  }

  String formatRupiah(int number) {
    final text = number.toString();
    final buffer = StringBuffer();

    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      count++;
      buffer.write(text[i]);

      if (count % 3 == 0 && i != 0) {
        buffer.write(".");
      }
    }

    return "Rp ${buffer.toString().split('').reversed.join()}";
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }

  Future<void> refresh() async {
    setState(() {
      _future = _orderService.getOrders();
    });

    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Pesanan Saya",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<List<OrderModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final orders = snapshot.data ?? [];

            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 90,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Belum ada pesanan",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, index) {
                final order = orders[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderDetailScreen(
                          orderId: order.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink
                              .withOpacity(.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order #${order.id}",
                              style:
                                  GoogleFonts.poppins(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: statusColor(
                                        order.status)
                                    .withOpacity(.15),
                                borderRadius:
                                    BorderRadius
                                        .circular(20),
                              ),
                              child: Text(
                                order.status,
                                style:
                                    GoogleFonts.poppins(
                                  color: statusColor(
                                      order.status),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          order.recipientName,
                          style:
                              GoogleFonts.poppins(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          order.phone,
                          style:
                              GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_bag,
                              size: 18,
                              color:
                                  Color(0xffFF5C8A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${order.items.length} Produk",
                              style:
                                  GoogleFonts.poppins(),
                            ),
                            const Spacer(),
                            Text(
                              formatRupiah(
                                  order.totalPrice),
                              style:
                                  GoogleFonts.poppins(
                                fontWeight:
                                    FontWeight.bold,
                                color: const Color(
                                    0xffFF5C8A),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}