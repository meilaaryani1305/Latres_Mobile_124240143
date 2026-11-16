
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

  Future<void> getFavorites() async {
    try {
      var box = Hive.box<String>(favoritesBoxName);

      List<dynamic> allShows = await service.getShows();

      List<dynamic> favoriteShows = allShows.where((show) {
        return box.containsKey(show['id'].toString());
      }).toList();

      setState(() {
        favorites = favoriteShows;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteFavorite(String id) {
    var box = Hive.box<String>(favoritesBoxName);

    box.delete(id);

    setState(() {
      favorites.removeWhere(
        (show) => show['id'].toString() == id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Serial berhasil dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (favorites.isEmpty) {
      return Center(
        child: Text(
          'Belum ada serial favorit',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        var show = favorites[index];

        String id = show['id'].toString();

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

            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteFavorite(id);
              },
            ),

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
}
