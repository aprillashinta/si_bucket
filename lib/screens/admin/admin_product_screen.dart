import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:si_bucket/models/admin_product_model.dart';
import 'package:si_bucket/screens/admin/add_product_screen.dart';
import 'package:si_bucket/services/admin_product_service.dart';
import 'package:si_bucket/screens/admin/edit_product_screen.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final AdminProductService _service = AdminProductService();

  List<AdminProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      products = await _service.getProducts();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteProduct(int id) async {
    final result = await _service.deleteProduct(id);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));

      await loadProducts();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menghapus produk")));
    }
  }

  void confirmDelete(AdminProductModel product) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Hapus Produk"),
          content: Text("Yakin ingin menghapus ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                deleteProduct(product.id!);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Future<void> goToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );

    if (result == true) {
      loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Produk",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddProduct,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: loadProducts,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
            ? Center(
                child: Text("Belum ada produk", style: GoogleFonts.poppins()),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product.image.isNotEmpty
                            ? Image.network(
                                "http://localhost:3000${product.image}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      title: Text(
                        product.name,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kategori : ${product.categoryName ?? "-"}"),
                            Text("Harga : Rp ${product.price}"),
                            Text("Stock : ${product.stock}"),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 96,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProductScreen(
                                      productId: product.id!,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  loadProducts();
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                confirmDelete(product);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
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
