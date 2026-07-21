import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/admin_user_model.dart';
import '../../services/admin_user_service.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  final AdminUserService _service = AdminUserService();

  List<AdminUserModel> users = [];
  List<AdminUserModel> filteredUsers = [];

  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUsers();

    searchController.addListener(() {
      search(searchController.text);
    });
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
    });

    users = await _service.getUsers();
    filteredUsers = users;

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void search(String value) {
    setState(() {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(value.toLowerCase()) ||
            user.email.toLowerCase().contains(value.toLowerCase()) ||
            user.phone.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteUser(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text(
            "Yakin ingin menghapus user ini?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final result = await _service.deleteUser(id);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User berhasil dihapus"),
        ),
      );

      loadUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus user"),
        ),
      );
    }
  }

  Widget infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: Text(
          "Kelola User",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadUsers,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Cari user...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredUsers.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada user",
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          child: Text(
                                            user.name.isNotEmpty
                                                ? user.name[0]
                                                    .toUpperCase()
                                                : "?",
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.name,
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                user.email,
                                                style:
                                                    GoogleFonts.poppins(
                                                  color:
                                                      Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        infoChip(
                                          user.role.toUpperCase(),
                                          user.role == "admin"
                                              ? Colors.red
                                              : Colors.teal,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          user.phone,
                                          style:
                                              GoogleFonts.poppins(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            user.address,
                                            style:
                                                GoogleFonts.poppins(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Edit User akan dibuat berikutnya",
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                          ),
                                          label: const Text("Edit"),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            deleteUser(user.id);
                                          },
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red,
                                          ),
                                          icon: const Icon(
                                            Icons.delete,
                                          ),
                                          label:
                                              const Text("Hapus"),
                                        ),
                                      ],
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
    );
  }
}