import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin_order_model.dart';
import '../../services/admin_order_service.dart';
import 'order_detail_screen.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {

  final AdminOrderService _service =
      AdminOrderService();

  List<AdminOrderModel> orders = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      orders = await _service.getOrders();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;

      case "paid":
        return Colors.blue;

      case "processed":
        return Colors.indigo;

      case "shipped":
        return Colors.purple;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String statusText(String status) {
    switch (status) {
      case "pending":
        return "Pending";

      case "paid":
        return "Paid";

      case "processed":
        return "Diproses";

      case "shipped":
        return "Dikirim";

      case "completed":
        return "Selesai";

      case "cancelled":
        return "Dibatalkan";

      default:
        return status;
    }
  }

  Future<void> openDetail(
      AdminOrderModel order) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(
          orderId: order.id,
        ),
      ),
    );

    if (result == true) {
      loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Pesanan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadOrders,
        child: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : orders.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada pesanan",
                      style:
                          GoogleFonts.poppins(),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder:
                        (context, index) {

                      final order =
                          orders[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        elevation: 2,
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                          onTap: () {
                            openDetail(order);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                                    16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order #${order.id}",
                                      style:
                                          GoogleFonts
                                              .poppins(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: statusColor(
                                                order.status)
                                            .withValues(
                                                alpha:
                                                    0.15),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                      ),
                                      child: Text(
                                        statusText(
                                            order
                                                .status),
                                        style:
                                            GoogleFonts
                                                .poppins(
                                          color:
                                              statusColor(
                                                  order
                                                      .status),
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 12),

                                Text(
                                  order.customerName,
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                Text(
                                  order.customerEmail,
                                ),

                                Text(
                                  order.customerPhone,
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                  "Total : Rp ${order.totalPrice}",
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                                                const SizedBox(height: 6),

                                Text(
                                  "Metode Pembayaran : ${order.paymentMethod}",
                                  style: GoogleFonts.poppins(),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        order.shippingAddress,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Lihat Detail →",
                                    style: GoogleFonts.poppins(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
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
    );
  }
}