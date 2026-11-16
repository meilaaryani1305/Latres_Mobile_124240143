
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
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFF6750A4),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            Text(
              'Profil Pengguna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF6750A4),
                ),
                title: Text('Username'),
                subtitle: Text(username),
              ),
            ),

            SizedBox(height: 20),

            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kesan dan Pesan Praktikum',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Selama mengikuti praktikum mobile, '
                      'saya mendapatkan banyak pengalaman '
                      'dalam mempelajari pengembangan aplikasi '
                      'menggunakan Flutter. Praktikum ini membantu '
                      'saya memahami penggunaan API, penyimpanan '
                      'data, dan pembuatan tampilan aplikasi.',
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: Icon(Icons.logout),
                label: Text('LOGOUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
