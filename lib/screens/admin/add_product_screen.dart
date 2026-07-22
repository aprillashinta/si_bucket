import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/admin_category_model.dart';
import '../../models/admin_product_model.dart';
import '../../services/admin_category_service.dart';
import '../../services/admin_product_service.dart';
import '../../services/upload_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  final AdminProductService _productService = AdminProductService();
  final AdminCategoryService _categoryService = AdminCategoryService();
  final UploadService _uploadService = UploadService();

  final ImagePicker _picker = ImagePicker();

  List<AdminCategoryModel> categories = [];

  int? selectedCategory;

  File? _selectedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final data = await _categoryService.getCategories();

    setState(() {
      categories = data;

      if (categories.isNotEmpty) {
        selectedCategory = categories.first.id;
      }
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Silakan pilih kategori")));
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih gambar produk")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final imagePath = await _uploadService.uploadImage(_selectedImage!);

    if (imagePath == null) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload gambar gagal")));

      return;
    }

    final product = AdminProductModel(
      categoryId: selectedCategory!,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: int.tryParse(_priceController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      image: imagePath,
    );

    final result = await _productService.createProduct(product);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menambahkan produk")));
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Produk",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: selectedCategory,
                      decoration: inputDecoration("Kategori"),
                      items: categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: inputDecoration("Nama Produk"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama produk wajib diisi";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: inputDecoration("Deskripsi"),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi wajib diisi";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration("Harga"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Harga wajib diisi";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration("Stock"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Stock wajib diisi";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Foto Produk",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.pink.shade200),
                          color: Colors.grey.shade50,
                        ),
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 60,
                                    color: Colors.pink.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Pilih Gambar",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Tap untuk membuka galeri",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : saveProduct,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Simpan",
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
    );
  }
}
