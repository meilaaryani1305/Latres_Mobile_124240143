
import 'package:flutter/material.dart';

import '../services/api.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<dynamic> shows = [];
  bool isLoading = true;
  String errorMessage = '';

  Api service = Api();

  @override
  void initState() {
    super.initState();
    getShows();
  }

  Future<void> getShows() async {
    try {
      List<dynamic> data = await service.getShows();

      setState(() {
        shows = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data serial TV';
      });
    }
  }

  Widget homeContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = '';
                });

                getShows();
              },
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: shows.length,
      itemBuilder: (context, index) {
        var show = shows[index];

        String image = '';

        if (show['image'] != null) {
          image = show['image']['medium'] ?? '';
        }

        return Card(
          margin: EdgeInsets.only(bottom: 15),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),

            leading: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.tv, size: 50);
                    },
                  )
                : Icon(Icons.tv, size: 50),

            title: Text(
              show['name'] ?? 'Tidak ada judul',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              'Rating: ${show['rating']?['average'] ?? '-'}',
            ),

            trailing: Icon(Icons.arrow_forward_ios),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(show: show),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      homeContent(),
      FavoritePage(),
      ProfilePage(username: widget.username),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('SeriesKu'),
        backgroundColor: Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: Color(0xFF6750A4),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
