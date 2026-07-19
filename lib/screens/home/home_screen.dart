import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/product/detail_product_screen.dart';
import '../../services/cart_service.dart';
import '../../services/home_service.dart';
import '../order/order_history_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService homeService = HomeService();
  final CartService cartService = CartService();

  final TextEditingController searchController = TextEditingController();

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  bool isLoading = true;

  String selectedCategoryId = "";
  String searchKeyword = "";

  int cartCount = 0;
  int currentIndex = 0;

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

      final carts = await cartService.getCart();

      cartCount = carts.length;

      if (categories.isNotEmpty && selectedCategoryId.isEmpty) {
        selectedCategoryId = categories.first.id.toString();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  String rupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";
  }

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final categoryMatch =
          selectedCategoryId.isEmpty ||
          product.categoryId.toString() == selectedCategoryId;

      final searchMatch = product.name.toLowerCase().contains(
        searchKeyword.toLowerCase(),
      );

      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: Text(
          "Si Bucket",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xffEC407A),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );

                  loadData();
                },
              ),

              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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

          if (constraints.maxWidth >= 1024) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth >= 700) {
            crossAxisCount = 3;
          }

          return RefreshIndicator(
            color: const Color(0xffEC407A),
            onRefresh: loadData,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xffEC407A)),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Halo, Rae 👋",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Temukan bucket favoritmu hari ini",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      searchKeyword = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Cari Bucket...",
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xffEC407A),
                                    ),
                                    hintStyle: GoogleFonts.poppins(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffF06292),
                                      Color(0xffEC407A),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -10,
                                      bottom: -10,
                                      child: Icon(
                                        Icons.local_florist,
                                        color: Colors.white.withOpacity(.15),
                                        size: 160,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "🌸 PROMO 🌸",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          Text(
                                            "Diskon hingga 30%",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            "Untuk seluruh Bucket Graduation",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white.withOpacity(
                                                .9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kategori",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${categories.length} Kategori",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 95,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];

                              final isSelected =
                                  selectedCategoryId == category.id.toString();

                              IconData icon = Icons.local_florist;

                              if (index < categoryIcons.length) {
                                icon = categoryIcons[index]["icon"];
                              }

                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryId = category.id
                                          .toString();
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        width: 58,
                                        height: 58,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(0xffEC407A)
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xffEC407A)
                                                : Colors.grey.shade200,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                .05,
                                              ),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          icon,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xffEC407A),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        category.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? const Color(0xffEC407A)
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Produk",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${filteredProducts.length} Produk",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (filteredProducts.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 70,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Produk tidak ditemukan",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: .62,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = filteredProducts[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(22),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailProductScreen(
                                        productId: product.id,
                                      ),
                                    ),
                                  ).then((_) => loadData());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffFCE4EC,
                                                ).withOpacity(.45),
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(22),
                                                    ),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.local_florist,
                                                  size: 65,
                                                  color: Color(0xffEC407A),
                                                ),
                                              ),
                                            ),

                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  color: Color(0xffEC407A),
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: Colors.amber,
                                                ),

                                                const SizedBox(width: 4),

                                                Text(
                                                  "4.9",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                const Spacer(),

                                                Text(
                                                  "Stok ${product.stock}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            Text(
                                              product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              rupiah(product.price),
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xffEC407A),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 36,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                DetailProductScreen(
                                                                  productId:
                                                                      product
                                                                          .id,
                                                                ),
                                                          ),
                                                        ).then(
                                                          (_) => loadData(),
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xffEC407A,
                                                            ),
                                                        foregroundColor:
                                                            Colors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Order",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 8),

                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () async {
                                                    try {
                                                      await cartService
                                                          .addToCart(
                                                            productId:
                                                                product.id,
                                                            quantity: 1,
                                                          );

                                                      if (!mounted) return;

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                            "${product.name} ditambahkan ke keranjang",
                                                          ),
                                                        ),
                                                      );

                                                      loadData();
                                                    } catch (e) {
                                                      if (!mounted) return;

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            e.toString(),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xffFCE4EC,
                                                      ).withOpacity(.6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.add_shopping_cart,
                                                      color: Color(0xffEC407A),
                                                      size: 20,
                                                    ),
                                                  ),
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
                            }, childCount: filteredProducts.length),
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xffEC407A),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        onTap: (index) async {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              break;

            case 1:
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );

              loadData();
              break;

            case 2:
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );

              loadData();
              break;

            case 3:
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
            // case 3:
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("Profile sedang dikembangkan")),
            //   );
            //   break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Pesanan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
