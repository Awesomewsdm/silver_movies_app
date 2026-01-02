import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silver_movies_app/models/movie_model.dart';
import 'package:silver_movies_app/pages/movie/movie_page.dart';
import 'package:silver_movies_app/widgets/app_chip.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  void goToMoviePage(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, _) => FadeTransition(
          opacity: __,
          child: MoviePage(movie: movie),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () => goToMoviePage(context, movie),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 250,
        height: 430,
        child: Stack(
          children: [
            Hero(
              tag: movie.name,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: movie.image,
                  width: 300,
                  height: 533,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[900],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppChip(
                    text: 'IMDB 8.1',
                    color: Colors.yellow,
                    textColor: Colors.black,
                  ),
                  const Spacer(),
                  Text(
                    movie.name,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 10,
                        ),
                      ],
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
