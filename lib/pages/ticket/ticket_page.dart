import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silver_movies_app/models/movie_model.dart';
import 'package:silver_movies_app/widgets/dotted_line.dart';
import 'package:silver_movies_app/widgets/glass_icon_button.dart';
import 'package:silver_movies_app/widgets/scaleup_animation.dart';
import 'package:silver_movies_app/widgets/translate_animation.dart';
import 'package:silver_movies_app/widgets/translateup_animation.dart';

class TicketClipper extends CustomClipper<Path> {
  final double cutoutRadius;
  final double cutoutPosition;

  TicketClipper({this.cutoutRadius = 20.0, required this.cutoutPosition});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);

    // Top edge to right
    path.lineTo(size.width, 0);

    // Right edge down to cutout
    path.lineTo(size.width, cutoutPosition - cutoutRadius);

    // Right semicircular cutout
    path.arcToPoint(
      Offset(size.width, cutoutPosition + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Right edge down to bottom
    path.lineTo(size.width, size.height);

    // Bottom edge to left
    path.lineTo(0, size.height);

    // Left edge up to cutout
    path.lineTo(0, cutoutPosition + cutoutRadius);

    // Left semicircular cutout
    path.arcToPoint(
      Offset(0, cutoutPosition - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Left edge up to top
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TicketPage extends StatelessWidget {
  const TicketPage({super.key, required this.movie});

  final Movie movie;

  Widget _buildTicket({double opacity = 1.0}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Opacity(
        opacity: opacity,
        child: ClipPath(
          clipper: TicketClipper(cutoutRadius: 20, cutoutPosition: 430),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: movie.image,
                  width: double.infinity,
                  height: double.infinity,
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
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Column(
                        children: [
                          const DottedLine(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  movie.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'May 15, 20:00',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Image.asset(
                                  'assets/qr.png',
                                  height: 100,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: movie.image,
            width: double.infinity,
            height: double.infinity,
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
                  size: 48,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withValues(alpha: 0.1)),
          ),
          // Left ticket (behind)
          Positioned(
            top: 190,
            left: 20,
            right: 80,
            bottom: 120,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0002)
                ..rotateZ(-0.02),
              alignment: Alignment.topCenter,
              child: TranslateUpAnimation(child: _buildTicket(opacity: 0.5)),
            ),
          ),
          // Right ticket (behind)
          Positioned(
            top: 190,
            left: 80,
            right: 20,
            bottom: 120,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0002)
                ..rotateZ(0.02),
              alignment: Alignment.topCenter,
              child: TranslateUpAnimation(child: _buildTicket(opacity: 0.5)),
            ),
          ),
          // Center ticket (front)
          Positioned(
            top: 170,
            left: 40,
            right: 40,
            bottom: 120,
            child: TranslateRightAnimation(child: _buildTicket()),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ScaleUpAnimation(
                child: GlassIconButton(
                  onTap: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
