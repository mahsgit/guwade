// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:camera/camera.dart';
// import '../../../../core/constants/colors.dart';
// import '../../../../core/utils/face_recognition_util.dart';
// import '../../../../core/utils/text_to_speech_util.dart';
// import '../bloc/story_bloc.dart';
// import '../widgets/story_page_view.dart';
// import '../widgets/story_quiz_widget.dart';
// import '../widgets/mood_indicator.dart';

// class StoryDetailPage extends StatefulWidget {
//   final String storyId;

//   const StoryDetailPage({
//     Key? key,
//     required this.storyId,
//   }) : super(key: key);

//   @override
//   State<StoryDetailPage> createState() => _StoryDetailPageState();
// }

// class _StoryDetailPageState extends State<StoryDetailPage> {
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;
//   bool _isFaceDetectionEnabled = true;
//   String _currentMood = 'neutral';
  
//   @override
//   void initState() {
//     super.initState();
//     context.read<StoryBloc>().add(GetStoryDetailsEvent(widget.storyId));
//     _initializeCamera();
//   }
  
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     if (cameras.isEmpty) return;
    
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );
    
//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
    
//     await _cameraController!.initialize();
//     if (!mounted) return;
    
//     setState(() {
//       _isCameraInitialized = true;
//     });
    
//     // Start face detection
//     _startFaceDetection();
//   }
  
//   void _startFaceDetection() {
//     if (!_isCameraInitialized || !_isFaceDetectionEnabled) return;
    
//     // In a real app, this would use a more sophisticated approach
//     // For demo purposes, we'll simulate mood changes periodically
//     Future.delayed(const Duration(seconds: 5), () async {
//       if (!mounted || !_isFaceDetectionEnabled) return;
      
//       // Simulate mood detection
//       final moods = ['happy', 'sad', 'bored', 'neutral', 'excited'];
//       final randomIndex = DateTime.now().millisecondsSinceEpoch % moods.length;
//       final detectedMood = moods[randomIndex];
      
//       if (_currentMood != detectedMood) {
//         setState(() {
//           _currentMood = detectedMood;
//         });
        
//         // Update the story content based on mood
//         context.read<StoryBloc>().add(UpdateMoodEvent(detectedMood));
//       }
      
//       // Continue detection
//       _startFaceDetection();
//     });
//   }
  
//   @override
//   void dispose() {
//     _isFaceDetectionEnabled = false;
//     _cameraController?.dispose();
//     TextToSpeechUtil.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Story'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.bookmark_border),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: BlocBuilder<StoryBloc, StoryState>(
//         builder: (context, state) {
//           if (state is StoryDetailsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is StoryDetailsLoaded) {
//             final storyDetail = state.storyDetail;
//             final currentMood = state.currentMood;
            
//             return Column(
//               children: [
//                 // Mood indicator
//                 if (_isFaceDetectionEnabled)
//                   MoodIndicator(mood: currentMood),
                
//                 // Story content
//                 Expanded(
//                   child: StoryPageView(
//                     storyDetail: storyDetail,
//                     currentMood: currentMood,
//                   ),
//                 ),
                
//                 // Audio controls
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   color: AppColors.quaternary.withOpacity(0.2),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.skip_previous),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.play_arrow),
//                         onPressed: () {
//                           // Play the current page text
//                           final currentPage = storyDetail.pages.first;
//                           final adaptedContent = currentPage.adaptedContent[currentMood] ?? currentPage.content;
//                           TextToSpeechUtil.speak(adaptedContent);
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.pause),
//                         onPressed: () {
//                           TextToSpeechUtil.pause();
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           _isFaceDetectionEnabled ? Icons.face : Icons.face_retouching_off,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isFaceDetectionEnabled = !_isFaceDetectionEnabled;
//                           });
//                           if (_isFaceDetectionEnabled) {
//                             _startFaceDetection();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else if (state is StoryError) {
//             return Center(
//               child: Text(
//                 'Error: ${state.message}',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           } else {
//             return const Center(child: Text('Story not found'));
//           }
//         },
//       ),
//     );
//   }
// }
