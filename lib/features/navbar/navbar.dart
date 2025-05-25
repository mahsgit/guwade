import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBC02D),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home', context),
              _buildNavItem(1, Icons.book_rounded, 'Vocabulary', context),
              _buildProfileItem(),
              _buildNavItem(3, Icons.note_rounded, 'Achievements', context),
              _buildNavItem(4, Icons.person_rounded, 'Profile', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, BuildContext context) {
    final bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        onTap(index); // Call the provided onTap callback
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/vocabulary');
            break;
          case 3:
            Navigator.pushNamed(context, '/achievements');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 18, // Reduced from 22 to help with overflow
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 9, // Reduced from 11 to help with overflow
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem() {
    return Container(
      width: 32, // Reduced from 40 to align with constrained height
      height: 32, // Reduced from 40
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/mascot.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}