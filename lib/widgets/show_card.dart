
import 'package:flutter/material.dart';

class ShowCard extends StatelessWidget {
  final Map<String, dynamic> show;
  final VoidCallback onTap;
  final Widget? trailing;

  const ShowCard({
    super.key,
    required this.show,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    String image = '';

    if (show['image'] != null) {
      image = show['image']['medium'] ?? '';
    }

    String title = show['name'] ?? 'Tidak ada judul';

    String rating =
        show['rating']?['average']?.toString() ?? '-';

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
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Rating: $rating'),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
