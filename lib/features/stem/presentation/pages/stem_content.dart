// import 'package:buddy/features/stem/presentation/pages/stem_detail_page.dart';
// import 'package:flutter/material.dart';

// class StemPage extends StatefulWidget {
//   const StemPage({Key? key}) : super(key: key);

//   @override
//   State<StemPage> createState() => _StemPageState();
// }

// class _StemPageState extends State<StemPage> with AutomaticKeepAliveClientMixin {
//   final List<StemCategory> _categories = [
//     StemCategory(
//       id: 'math',
//       title: 'Mathematics',
//       description: 'Fun math concepts for young minds',
//       color: Colors.blue[700]!,
//       icon: Icons.calculate,
//       playlistUrl: 'https://www.youtube.com/watch?v=a4FXl4zb3E4&list=PLWphMREEQDrgzJPYI_t-DNVb3FjVsMs-K',
//       isAvailable: true,
//       progress: 0.2,
//     ),
//     StemCategory(
//       id: 'engineering',
//       title: 'Engineering',
//       description: 'Build and create amazing things',
//       color: Colors.orange[700]!,
//       icon: Icons.construction,
//       playlistUrl: 'https://www.youtube.com/watch?v=Ra7Bax6rGoQ&list=RDRa7Bax6rGoQ&start_radio=1',
//       isAvailable: true,
//       progress: 0.1,
//     ),
//     StemCategory(
//       id: 'science',
//       title: 'Science',
//       description: 'Discover how the world works',
//       color: Colors.green[700]!,
//       icon: Icons.science,
//       playlistUrl: '',
//       isAvailable: false,
//       progress: 0.0,
//     ),
//     StemCategory(
//       id: 'technology',
//       title: 'Technology',
//       description: 'Explore amazing gadgets and computers',
//       color: Colors.purple[700]!,
//       icon: Icons.computer,
//       playlistUrl: '',
//       isAvailable: false,
//       progress: 0.0,
//     ),
//     StemCategory(
//       id: 'diy',
//       title: 'DIY Projects',
//       description: 'Make your own cool creations',
//       color: Colors.red[700]!,
//       icon: Icons.build,
//       playlistUrl: '',
//       isAvailable: false,
//       progress: 0.0,
//     ),
//   ];

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
    
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),
//           _buildStemDescription(),
//           _buildCategoriesGrid(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       height: 180,
//       decoration: BoxDecoration(
//         color: Colors.teal[100],
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/stem_header.png',
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.teal[200],
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.science,
//                             size: 64,
//                             color: Colors.teal[700],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "STEM Learning",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.teal[800],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.7),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: const Text(
//                   "Explore STEM Subjects",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStemDescription() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.lightbulb,
//                 color: Colors.amber[700],
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 "What is STEM?",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "STEM stands for Science, Technology, Engineering, and Mathematics. These fun activities help kids learn important skills through play and exploration!",
//             style: TextStyle(
//               fontSize: 14,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _buildInfoChip(Icons.star, "Ages 4-8"),
//               const SizedBox(width: 8),
//               _buildInfoChip(Icons.school, "Kid-friendly"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoChip(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.teal[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.teal[200]!),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 16,
//             color: Colors.teal[700],
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.teal[700],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoriesGrid() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "STEM Categories",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 0.8,
//             ),
//             itemCount: _categories.length,
//             itemBuilder: (context, index) {
//               final category = _categories[index];
//               return _buildCategoryCard(category);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryCard(StemCategory category) {
//     return GestureDetector(
//       onTap: () {
//         if (category.isAvailable) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => StemDetailPage(
//                 category: category,
//               ),
//             ),
//           );
//         } else {
//           _showComingSoonDialog(category.title);
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Category header with icon
//             Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 color: category.color.withOpacity(0.8),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//               ),
//               child: Center(
//                 child: Icon(
//                   category.icon,
//                   size: 48,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             // Category details
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             category.title,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (!category.isAvailable)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.amber[100],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               "Soon",
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.amber[800],
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       category.description,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const Spacer(),
//                     if (category.isAvailable) ...[
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: LinearProgressIndicator(
//                                 value: category.progress,
//                                 backgroundColor: Colors.grey[200],
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   category.color,
//                                 ),
//                                 minHeight: 6,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             "${(category.progress * 100).toInt()}%",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showComingSoonDialog(String categoryTitle) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text(
//           "$categoryTitle Coming Soon!",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.upcoming,
//               size: 64,
//               color: Colors.amber[700],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "We're preparing exciting $categoryTitle videos for you. Stay tuned!",
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StemCategory {
//   final String id;
//   final String title;
//   final String description;
//   final Color color;
//   final IconData icon;
//   final String playlistUrl;
//   final bool isAvailable;
//   final double progress;

//   StemCategory({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.color,
//     required this.icon,
//     required this.playlistUrl,
//     required this.isAvailable,
//     required this.progress,
//   });
// }
