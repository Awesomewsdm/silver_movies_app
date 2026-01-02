import 'package:flutter/material.dart';
import 'package:silver_movies_app/widgets/glass_icon_button.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            GlassIconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
            GlassIconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
