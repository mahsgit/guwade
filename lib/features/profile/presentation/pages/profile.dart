// // lib/features/profile/presentation/pages/profile_page.dart
// import 'package:buddy/features/home/presentation/pages/dashboard.dart';
// import 'package:buddy/features/home/presentation/pages/setting.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(180),
//         child: _buildProfileHeader(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             _buildStatsRow(),
//             const SizedBox(height: 20),
//             _buildMenuSection(),
//             const SizedBox(height: 20),
//             _buildAccountSection(),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: AppBottomNavigation(
//       //   currentIndex: 3,
//       //   onTap: (index) {
//       //     if (index != 3) {
//       //       _navigateToPage(context, index);
//       //     }
//       //   },
//       // ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
//       decoration: const BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.arrow_back, color: Colors.black),
//                 ),
//               ),
//               const Text(
//                 'My Profile',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.menu, color: Colors.black),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.black,
//                 child: CircleAvatar(
//                   radius: 28,
//                   backgroundImage: AssetImage('assets/main.png'),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Abebe Kebede',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'UKG Student',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.edit, color: Colors.white),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem('2+ hours', 'Total Learn'),
//           _buildDivider(),
//           _buildStatItem('20', 'Achievements'),
//           _buildDivider(),
//           _buildStatItem('2', 'Languages'),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       height: 30,
//       width: 1,
//       color: Colors.grey[300],
//     );
//   }

//   Widget _buildMenuSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildMenuItem(
//             'Dashboard',
//             Icons.dashboard,
//             Colors.blue,
//             () => _navigateToPage(context, 0),
//           ),
//           const Divider(height: 20),
//           _buildMenuItem(
//             'Settings',
//             Icons.settings,
//             Colors.blue,
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SettingsPage()),
//             ),
//           ),
//           const Divider(height: 20),
//           _buildMenuItem(
//             'Achievements',
//             Icons.emoji_events,
//             Colors.amber,
//             () {},
//             badge: '2 New',
//             badgeColor: Colors.blue,
//           ),
//           const Divider(height: 20),
//           _buildMenuItem(
//             'Privacy',
//             Icons.lock,
//             Colors.grey,
//             () {},
//             badge: 'Action Needed',
//             badgeColor: Colors.orange,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem(
//     String title,
//     IconData icon,
//     Color iconColor,
//     VoidCallback onTap, {
//     String? badge,
//     Color? badgeColor,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: iconColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: iconColor),
//             ),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//               ),
//             ),
//             const Spacer(),
//             if (badge != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: badgeColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   badge,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             if (badge == null) const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAccountSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.purple.withOpacity(0.5), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'My Account',
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 15),
//           InkWell(
//             onTap: () {},
//             child: const Text(
//               'Switch to Another Account',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           InkWell(
//             onTap: () {},
//             child: const Text(
//               'Logout Account',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Colors.redAccent,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToPage(BuildContext context, int index) {
//     Widget page;
//     switch (index) {
//       case 0:
//         page =  const DashboardPage();
//         break;
//       case 1:
//         // Search page
//         page = const Scaffold(body: Center(child: Text('Search')));
//         break;
//       case 2:
//         // Achievement page
//         page = const Scaffold(body: Center(child: Text('Achievements')));
//         break;
//       case 3:
//         // Already on profile page
//         return;
//       default:
//         page =  const DashboardPage();
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }
// }



import 'package:buddy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Using dummy data for now, will integrate with backend later
          // You can replace this with actual data from state when backend is ready
          final String name = state is ProfileLoaded ? state.user.nickname : "John Doe";
          final int age = state is ProfileLoaded 
              ? _calculateAge(state.user.birthDate)
              : 8;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Row(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.orange[100],
                            child: const Icon(Icons.person, color: Colors.brown, size: 50),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Name and Edit Button
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text(
                              '$age Years old',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Stats Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('2+ hours', 'Learning Time'),
                      _buildDivider(),
                      _buildStatItem('20', 'Lessons'),
                      _buildDivider(),
                      _buildStatItem('2', 'Badges'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Dashboard Section
                _buildSectionHeader('Dashboard'),
                
                // Settings Section
                _buildSectionHeader('Settings'),
                _buildSettingsItem(
                  icon: Icons.emoji_events,
                  title: 'Achievements',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  icon: Icons.lock,
                  title: 'Privacy',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Update needed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // My Account Section
                _buildSectionHeader('My Account'),
                _buildSettingsItem(
                  icon: Icons.swap_horiz,
                  title: 'Switch to Another Account',
                ),
                _buildSettingsItem(
                  icon: Icons.calendar_today,
                  title: 'Original Schedule',
                ),
                
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Profile tab is selected
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.grey[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
  
  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    final age = currentDate.year - birthDate.year;
    return birthDate.month > currentDate.month ||
            (birthDate.month == currentDate.month && birthDate.day > currentDate.day)
        ? age - 1
        : age;
  }
}
