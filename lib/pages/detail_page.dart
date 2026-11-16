
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/api.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> show;

  const DetailPage({super.key, required this.show});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String favoritesBoxName = 'favorites';

  bool isFavorite = false;
  bool isLoading = true;

  Map<String, dynamic> showDetails = {};

  Api service = Api();

  @override
  void initState() {
    super.initState();

    showDetails = Map<String, dynamic>.from(widget.show);

    checkFavorite();
    getShowDetails();
  }

  // Memeriksa apakah serial sudah menjadi favorit
  void checkFavorite() {
    var box = Hive.box<String>(favoritesBoxName);

    isFavorite = box.containsKey(widget.show['id'].toString());
  }

  // Mengambil detail serial TV dari API
  Future<void> getShowDetails() async {
    try {
      int id = widget.show['id'];

      Map<String, dynamic> data =
          await service.getShowDetails(id);

      if (!mounted) return;

      setState(() {
        showDetails = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // Menambah atau menghapus favorit
  void toggleFavorite() {
    var box = Hive.box<String>(favoritesBoxName);

    String id = showDetails['id'].toString();

    if (isFavorite) {
      box.delete(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dihapus dari favorit'),
        ),
      );
    } else {
      box.put(id, showDetails['name'] ?? 'Tidak ada judul');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ditambahkan ke favorit'),
        ),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  // Membersihkan tag HTML dari sinopsis
  String cleanSummary(String summary) {
    return summary.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    String image = '';

    if (showDetails['image'] != null) {
      image = showDetails['image']['original'] ??
          showDetails['image']['medium'] ??
          '';
    }

    String title = showDetails['name'] ?? 'Tidak ada judul';

    String rating =
        showDetails['rating']?['average']?.toString() ?? '-';

    List<dynamic> genres = showDetails['genres'] ?? [];

    String summary = showDetails['summary'] ??
        'Sinopsis tidak tersedia';

    return Scaffold(
      backgroundColor: Colors.black,

      // AppBar
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF382F),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster serial TV
                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.movie,
                                color: Colors.grey,
                                size: 100,
                              );
                            },
                          )
                        : const Icon(
                            Icons.movie,
                            color: Colors.grey,
                            size: 100,
                          ),
                  ),

                  // Informasi serial
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama serial
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Genre
                        Text(
                          genres.isNotEmpty
                              ? genres.join(', ')
                              : 'Genre tidak tersedia',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Tombol Nonton dan Favorit
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Fitur pemutaran video belum tersedia',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 18,
                                  ),
                                  label: const Text('Nonton'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFFF382F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Tombol favorit
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFF292929),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: toggleFavorite,
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? const Color(0xFFFF382F)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Overview
                        const Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          cleanSummary(summary),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
