import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:silver_movies_app/models/movie_model.dart';

class TrendingMoviesService {
  TrendingMoviesService({this.baseUrl = 'https://silver-movies.onrender.com'});

  final String baseUrl;

  Future<List<Movie>> fetchTrending() async {
    final uri = Uri.parse('$baseUrl/api/movies/trending/');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data is List) {
        return data
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data.containsKey('results')) {
        final results = data['results'] as List;
        return results
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch trending movies: ${res.statusCode}');
    }
  }
}
