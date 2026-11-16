
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<List<dynamic>> getShows() async {
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/shows'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data serial TV');
    }
  }

  Future<Map<String, dynamic>> getShowDetails(int id) async {
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/shows/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil detail serial TV');
    }
  }
}
