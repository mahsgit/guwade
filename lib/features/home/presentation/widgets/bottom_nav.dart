import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final GlobalKey<CurvedNavigationBarState> navigationKey;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navigationKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          key: navigationKey,
          index: currentIndex,
          color: Colors.transparent,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          height: 75,
          animationCurve: Curves.easeOutCubic,
          animationDuration: const Duration(milliseconds: 600),
          items: [
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home,
                  color: currentIndex == 1 ? Colors.white : Colors.grey,
                  size: 24,
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    color: currentIndex == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  currentIndex == 0 ? Icons.science : Icons.science_outlined,
                  color: currentIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 24,
                ),
                Text(
                  'WORDS',
                  style: TextStyle(
                    color: currentIndex == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  currentIndex == 2 ? Icons.book : Icons.book_outlined,
                  color: currentIndex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 24,
                ),
                Text(
                  'Achievements ',
                  style: TextStyle(
                    color: currentIndex == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}