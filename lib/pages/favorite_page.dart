
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/api.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favorites = [];

  bool isLoading = true;

  Api service = Api();

  String favoritesBoxName = 'favorites';

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  // Mengambil daftar serial favorit
  Future<void> getFavorites() async {
    try {
      var box = Hive.box<String>(favoritesBoxName);

      List<dynamic> allShows = await service.getShows();

      List<dynamic> favoriteShows = allShows.where((show) {
        return box.containsKey(show['id'].toString());
      }).toList();

      if (!mounted) return;

      setState(() {
        favorites = favoriteShows;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // Menghapus serial dari favorit
  void deleteFavorite(String id) {
    var box = Hive.box<String>(favoritesBoxName);

    box.delete(id);

    setState(() {
      favorites.removeWhere(
        (show) => show['id'].toString() == id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Serial berhasil dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul halaman
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Text(
              'Daftar Favorit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Loading
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF382F),
                ),
              ),
            )

          // Jika belum ada favorit
          else if (favorites.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Belum ada serial favorit',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            )

          // Daftar favorit
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  var show = favorites[index];

                  String id = show['id'].toString();

                  String image = '';

                  if (show['image'] != null) {
                    image = show['image']['medium'] ?? '';
                  }

                  String title =
                      show['name'] ?? 'Tidak ada judul';

                  String rating = show['rating']?['average']
                          ?.toString() ??
                      '-';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),

                      // Poster serial
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: image.isNotEmpty
                            ? Image.network(
                                image,
                                width: 45,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 45,
                                    height: 50,
                                    child: Icon(
                                      Icons.movie,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(
                                width: 45,
                                height: 50,
                                child: Icon(
                                  Icons.movie,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      // Nama dan rating serial
                      title: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
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

                      // Tombol hapus
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xFFFF382F),
                        ),
                        onPressed: () {
                          deleteFavorite(id);
                        },
                      ),

                      // Masuk ke halaman detail
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(show: show),
                          ),
                        );

                        getFavorites();
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
