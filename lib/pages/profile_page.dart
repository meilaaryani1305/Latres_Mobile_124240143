
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  final String sessionKey = 'logged_in_username';

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(sessionKey);

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Column(
        children: [
          // Judul halaman
          const Padding(
            padding: EdgeInsets.only(top: 22),
            child: Text(
              'Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),

          // Isi profil
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Foto profil
                    const CircleAvatar(
                      radius: 51,
                      backgroundColor: Color(0xFF424242),
                      child: Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Username
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Kesan dan pesan
                    const Text(
                      'Kesan: Banyak pengalaman baru selama praktikum, mulai dari belajar coding hingga mengejar codingan kak alfin yang sangat cepat, makasih kak alfin dan kak umar atas bimbingannya\n'
                      'Pesan: Semoga kak alfin dan kak umar lancar mengerjakan TA nya, dan semoga nilai praktikum mobile saya A, AAMIIN\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Logout
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          _logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF382F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
