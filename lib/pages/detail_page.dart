
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> show;

  const DetailPage({super.key, required this.show});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String favoritesBoxName = 'favorites';

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  void checkFavorite() {
    var box = Hive.box<String>(favoritesBoxName);

    setState(() {
      isFavorite = box.containsKey(widget.show['id'].toString());
    });
  }

  void toggleFavorite() {
    var box = Hive.box<String>(favoritesBoxName);

    String id = widget.show['id'].toString();

    if (isFavorite) {
      box.delete(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dihapus dari favorit'),
        ),
      );
    } else {
      box.put(id, widget.show['name']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ditambahkan ke favorit'),
        ),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    String image = '';

    if (widget.show['image'] != null) {
      image = widget.show['image']['original'] ?? '';
    }

    List<dynamic> genres = widget.show['genres'] ?? [];

    String rating =
        widget.show['rating']?['average']?.toString() ?? '-';

    String summary = widget.show['summary'] ?? 'Sinopsis tidak tersedia';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Serial TV'),
        backgroundColor: Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      height: 300,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.tv, size: 150);
                      },
                    )
                  : Icon(Icons.tv, size: 150),
            ),

            SizedBox(height: 20),

            Text(
              widget.show['name'] ?? 'Tidak ada judul',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.star, color: Colors.orange),
                SizedBox(width: 5),
                Text(
                  'Rating: $rating',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),

            SizedBox(height: 15),

            Text(
              'Genre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              genres.isNotEmpty
                  ? genres.join(', ')
                  : 'Genre tidak tersedia',
            ),

            SizedBox(height: 20),

            Text(
              'Sinopsis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              summary.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite
                      ? 'Hapus dari Favorit'
                      : 'Tambah ke Favorit',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6750A4),
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
