import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin_order_model.dart';
import '../../services/admin_order_service.dart';
import 'order_detail_screen.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final AdminOrderService _service = AdminOrderService();

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

      // Opsional: Tetap tampilkan snackbar jika ada error API
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    // --- FITUR DUMMY DATA ---
    // Jika data dari API kosong/error, maka fallback menggunakan dummy data untuk preview tampilan
    if (orders.isEmpty) {
      orders = _getDummyOrders();
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  /// Generator data dummy untuk testing tampilan
  /// Generator data dummy untuk testing tampilan
  List<AdminOrderModel> _getDummyOrders() {
    return [
      AdminOrderModel(
        id: 1001,
        userId: 1,
        recipientName: "Siti Rahmawati",
        phone: "081234567890",
        shippingAddress: "Jl. Mawar No. 12, Kebayoran Baru, Jakarta Selatan",
        notes: "Tolong bungkus dengan pita merah ya",
        paymentMethod: "Transfer Bank (BCA)",
        totalPrice: 150000,
        status: "pending",
        createdAt: "2026-07-22 10:00:00",
        customerName: "Siti Rahmawati",
        customerEmail: "siti.rahma@gmail.com",
        customerPhone: "081234567890",
      ),
      AdminOrderModel(
        id: 1002,
        userId: 2,
        recipientName: "Budi Santoso",
        phone: "085678901234",
        shippingAddress: "Jl. Anggrek Raya No. 45, Coblong, Bandung",
        notes: "Kirim sebelum jam 12 siang",
        paymentMethod: "E-Wallet (Gopay)",
        totalPrice: 275000,
        status: "paid",
        createdAt: "2026-07-22 11:30:00",
        customerName: "Budi Santoso",
        customerEmail: "budi.santoso@yahoo.com",
        customerPhone: "085678901234",
      ),
      AdminOrderModel(
        id: 1003,
        userId: 3,
        recipientName: "Dewi Lestari",
        phone: "087812345678",
        shippingAddress: "Jl. Diponegoro No. 88, Tegalsari, Surabaya",
        notes: "Buket bunga untuk ucapan wisuda",
        paymentMethod: "QRIS",
        totalPrice: 320000,
        status: "processed",
        createdAt: "2026-07-21 14:15:00",
        customerName: "Dewi Lestari",
        customerEmail: "dewi.lestari@gmail.com",
        customerPhone: "087812345678",
      ),
      AdminOrderModel(
        id: 1004,
        userId: 4,
        recipientName: "Rian Hidayat",
        phone: "089612345678",
        shippingAddress: "Jl. Pemuda No. 101, Semarang Tengah, Semarang",
        notes: "Titipkan ke satpam jika rumah kosong",
        paymentMethod: "Transfer Bank (Mandiri)",
        totalPrice: 185000,
        status: "shipped",
        createdAt: "2026-07-20 09:45:00",
        customerName: "Rian Hidayat",
        customerEmail: "rian.hidayat@gmail.com",
        customerPhone: "089612345678",
      ),
      AdminOrderModel(
        id: 1005,
        userId: 5,
        recipientName: "Anisa Putri",
        phone: "081398765432",
        shippingAddress: "Jl. Malioboro No. 15, Danurejan, Yogyakarta",
        notes: "Kartu ucapan: Happy Birthday Mom!",
        paymentMethod: "E-Wallet (ShopeePay)",
        totalPrice: 500000,
        status: "completed",
        createdAt: "2026-07-19 16:20:00",
        customerName: "Anisa Putri",
        customerEmail: "anisa.putri@gmail.com",
        customerPhone: "081398765432",
      ),
      AdminOrderModel(
        id: 1006,
        userId: 6,
        recipientName: "Ahmad Fauzi",
        phone: "082143658709",
        shippingAddress: "Jl. Gajah Mada No. 33, Medan Barat, Medan",
        notes: "-",
        paymentMethod: "COD",
        totalPrice: 95000,
        status: "cancelled",
        createdAt: "2026-07-18 08:10:00",
        customerName: "Ahmad Fauzi",
        customerEmail: "ahmad.fauzi@gmail.com",
        customerPhone: "082143658709",
      ),
    ];
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

  Future<void> openDetail(AdminOrderModel order) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: order.id)),
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadOrders,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
            ? Center(
                child: Text("Belum ada pesanan", style: GoogleFonts.poppins()),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        openDetail(order);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Order #${order.id}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor(
                                      order.status,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusText(order.status),
                                    style: GoogleFonts.poppins(
                                      color: statusColor(order.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              order.customerName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(order.customerEmail),
                            Text(order.customerPhone),
                            const SizedBox(height: 10),
                            Text(
                              "Total : Rp ${order.totalPrice}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
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
