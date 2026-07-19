import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/profile_model.dart';
import '../../services/profile_service.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  ProfileModel? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildItem(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade50,
          child: Icon(icon, color: Colors.pink),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Text(
          value.isEmpty ? "-" : value,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profil Saya")),
        body: const Center(child: Text("Data profile tidak ditemukan")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.pink.shade100,
              child: const Icon(Icons.person, color: Colors.white, size: 60),
            ),

            const SizedBox(height: 16),

            Text(
              profile!.name,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              profile!.email,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            buildItem(Icons.person_outline, "Nama", profile!.name),

            buildItem(Icons.email_outlined, "Email", profile!.email),

            buildItem(Icons.phone_outlined, "Nomor HP", profile!.phone),

            buildItem(Icons.location_on_outlined, "Alamat", profile!.address),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(profile: profile!),
                    ),
                  );

                  if (result == true) {
                    loadProfile();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile berhasil diperbarui"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.edit),
                label: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _profileService.logout();

                  if (!mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text(
                  "Logout",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
