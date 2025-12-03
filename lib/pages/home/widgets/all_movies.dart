import 'dart:math';

import 'package:flutter/material.dart';
import 'package:silver_movies_app/models/movie_model.dart';
import 'package:silver_movies_app/services/trending_service.dart';
import 'package:silver_movies_app/widgets/movie_card.dart';

class AllMovies extends StatefulWidget {
  const AllMovies({super.key});

  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  final TrendingMoviesService _service = TrendingMoviesService();
  List<Movie>? _movies;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    try {
      final fetched = await _service.fetchTrending();
      if (mounted) {
        setState(() {
          _movies = fetched.isNotEmpty ? fetched : movies;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _movies = movies; // fallback to local list
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final useMovies = _movies ?? movies;
    final columns = sqrt(useMovies.length).toInt();
    return SizedBox(
      width: columns * 320,
      child: _movies == null
          ? const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Failed to fetch trending movies: $_error',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                Wrap(
                  children: List.generate(
                    useMovies.length,
                    (index) => Transform.translate(
                      offset: Offset(0, index.isEven ? 240 : 0),
                      child: MovieCard(movie: useMovies[index]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
