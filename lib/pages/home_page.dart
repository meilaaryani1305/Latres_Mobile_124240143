
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

      if (!mounted) return;

      setState(() {
        shows = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data serial TV';
      });
    }
  }

  // Tampilan halaman Home
  Widget homeContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF382F),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = '';
                });

                getShows();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 5, 18, 15),
      itemCount: shows.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 15,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        var show = shows[index];

        String image = '';

        if (show['image'] != null) {
          image = show['image']['medium'] ?? '';
        }

        String title = show['name'] ?? 'Tidak ada judul';
        String rating =
            show['rating']?['average']?.toString() ?? '-';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(show: show),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292929),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster serial TV
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.movie,
                                color: Colors.grey,
                                size: 50,
                              );
                            },
                          )
                        : const Icon(
                            Icons.movie,
                            color: Colors.grey,
                            size: 50,
                          ),
                  ),
                ),

                // Nama serial
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 9, 8, 4),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Rating serial
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      backgroundColor: Colors.black,

      // Bagian isi halaman
      body: SafeArea(
        child: selectedIndex == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 20),
                    child: Text(
                      'Skuy Nonton!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: pages[selectedIndex],
                  ),
                ],
              )
            : pages[selectedIndex],
      ),

      // Navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF382F),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
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
