import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin_order_model.dart';
import '../../services/admin_order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final AdminOrderService _service = AdminOrderService();

  AdminOrderModel? order;

  bool isLoading = true;
  bool isSaving = false;

  String? selectedStatus;

  final List<String> statuses = [
    "pending",
    "paid",
    "processed",
    "shipped",
    "completed",
    "cancelled",
  ];

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    order = await _service.getOrderById(widget.orderId);

    if (order != null) {
      selectedStatus = order!.status;
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateStatus() async {
    if (selectedStatus == null) return;

    setState(() {
      isSaving = true;
    });

    final result = await _service.updateStatus(widget.orderId, selectedStatus!);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Status berhasil diperbarui")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memperbarui status")));
    }
  }

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.poppins()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Pesanan")),
        body: const Center(child: Text("Data pesanan tidak ditemukan")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pesanan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${order!.id}",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                item("Nama Penerima", order!.recipientName),

                item("Nama Customer", order!.customerName),

                item("Email", order!.customerEmail),

                item("No. HP", order!.phone),

                item("Alamat Pengiriman", order!.shippingAddress),

                item("Metode Pembayaran", order!.paymentMethod),

                item("Catatan", order!.notes.isEmpty ? "-" : order!.notes),

                item("Total Pembayaran", "Rp ${order!.totalPrice}"),

                const SizedBox(height: 20),

                Text(
                  "Status Pesanan",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : updateStatus,
                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Update Status",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
