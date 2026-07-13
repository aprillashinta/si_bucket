import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:si_bucket/models/category_model.dart';
import 'package:si_bucket/models/product_model.dart';
import 'package:si_bucket/services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService homeService = HomeService();

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  String selectedCategoryId = "";
  int _currentNavbarIndex = 0;

  bool isLoading = true;

  final List<Map<String, dynamic>> categoryIcons = [
    {"name": "Mawar", "icon": Icons.local_florist},
    {"name": "Graduation", "icon": Icons.school},
    {"name": "Lily", "icon": Icons.yard},
    {"name": "Tulip", "icon": Icons.filter_vintage},
    {"name": "Mix", "icon": Icons.card_giftcard},
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      categories = await homeService.getCategories();
      products = await homeService.getProducts();
      
      if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
        selectedCategoryId = categories.first.id.toString(); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xffEC407A),
            behavior: SnackBarBehavior.floating,
            content: Text(e.toString(), style: GoogleFonts.poppins()),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  String rupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Si Bucket",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xffEC407A)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xffEC407A)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          double currentWidth = constraints.maxWidth;

          if (currentWidth >= 1024) {
            crossAxisCount = 4;
          } else if (currentWidth >= 600) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }

          return RefreshIndicator(
            onRefresh: loadData,
            color: const Color(0xffEC407A),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEC407A))))
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Halo, Rae 👋",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Selamat datang kembali",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Cari Bucket....",
                                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                                prefixIcon: const Icon(Icons.search, color: Color(0xffEC407A)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xffF06292), Color(0xffEC407A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -15,
                                  bottom: -15,
                                  child: Icon(Icons.school_outlined, size: 150, color: Colors.white.withOpacity(0.15)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "🌸 PROMO WISUDA 🌸",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white, 
                                          fontSize: 22, 
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Diskon hingga 30%",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white, 
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "Bucket Premium",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.9), 
                                          fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kategori",
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Lihat",
                                      style: GoogleFonts.poppins(color: const Color(0xffEC407A), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 95,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: categories.isNotEmpty ? categories.length : categoryIcons.length,
                                itemBuilder: (context, index) {
                                  final String name = categories.isNotEmpty ? categories[index].name : categoryIcons[index]["name"];
                                  final IconData icon = index < categoryIcons.length ? categoryIcons[index]["icon"] : Icons.local_florist;
                                  final String id = categories.isNotEmpty ? categories[index].id.toString() : index.toString();
                                  final isSelected = selectedCategoryId == id;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCategoryId = id;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xffEC407A) : Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected ? const Color(0xffEC407A) : Colors.grey.shade200,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(.04),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                )
                                              ],
                                            ),
                                            child: Icon(
                                              icon,
                                              color: isSelected ? Colors.white : const Color(0xffEC407A),
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              color: isSelected ? const Color(0xffEC407A) : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: Text(
                            "Produk Terbaru",
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.64,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = products[index];

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color(0xffFBDCE9).withOpacity(0.4),
                                          child: const Icon(
                                            Icons.local_florist_outlined,
                                            size: 50,
                                            color: Color(0xffEC407A),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              rupiah(product.price),
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xffEC407A),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "4.9",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Icon(
                                                  Icons.favorite_border,
                                                  size: 20,
                                                  color: Color(0xffEC407A),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: products.length,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavbarIndex,
        onTap: (index) {
          setState(() {
            _currentNavbarIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xffEC407A),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), activeIcon: Icon(Icons.local_shipping), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}