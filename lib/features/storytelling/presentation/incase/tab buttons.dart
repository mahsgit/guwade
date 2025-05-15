// Positioned(
//             bottom: 60,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _totalPages,
//                 (index) => GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _currentPage = index + 1;
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _currentPage == index + 1 ? Colors.blue : Colors.white,
//                       border: Border.all(
//                         color: Colors.grey[300]!,
//                         width: 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: _currentPage == index + 1 ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
