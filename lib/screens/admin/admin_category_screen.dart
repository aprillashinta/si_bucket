import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin_category_model.dart';
import '../../services/admin_category_service.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() =>
      _AdminCategoryScreenState();
}

class _AdminCategoryScreenState
    extends State<AdminCategoryScreen> {
  final AdminCategoryService _service =
      AdminCategoryService();

  List<AdminCategoryModel> categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() {
      isLoading = true;
    });

    categories = await _service.getCategories();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteCategory(int id) async {
    final result = await _service.deleteCategory(id);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kategori berhasil dihapus"),
        ),
      );

      loadCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus kategori"),
        ),
      );
    }
  }

  void confirmDelete(AdminCategoryModel category) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Hapus Kategori"),
          content: Text(
            "Yakin ingin menghapus ${category.name} ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteCategory(category.id);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Future<void> goToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCategoryScreen(),
      ),
    );

    if (result == true) {
      loadCategories();
    }
  }

  Future<void> goToEdit(AdminCategoryModel category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCategoryScreen(
          categoryId: category.id,
        ),
      ),
    );

    if (result == true) {
      loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kelola Kategori",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAdd,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: loadCategories,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.category),
                      ),
                      title: Text(
                        category.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                goToEdit(category);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                confirmDelete(category);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
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