// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class EmotionDetectionPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const EmotionDetectionPage({super.key, required this.cameras});

//   @override
//   State<EmotionDetectionPage> createState() => _EmotionDetectionPageState();
// }

// class _EmotionDetectionPageState extends State<EmotionDetectionPage> {
//   CameraController? _controller;
//   IsolateInterpreter? _isolateInterpreter;
//   final List<String> _emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral'];
//   Map<String, int> _emotionCounts = {};
//   String _currentEmotion = 'None';
//   bool _isProcessing = false;
//   int _frameCounter = 0;
//   final int _skipFrameInterval = 2;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: false,
//       enableClassification: false,
//       performanceMode: FaceDetectorMode.fast,
//     ),
//   );
//   int _skippedFrames = 0;
//   bool _modelLoaded = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     if (widget.cameras.isEmpty) {
//       print('Error: No cameras available');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No cameras available')),
//       );
//       return;
//     }
//     try {
//       _controller = CameraController(
//         widget.cameras[0],
//         ResolutionPreset.low,
//       );
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {});
//       await _controller!.startImageStream(_processImage);
//       print('Camera initialized successfully');
//     } catch (e) {
//       print('Error initializing camera: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error initializing camera: $e')),
//       );
//     }
//   }

//   Future<void> _loadModel() async {
//     try {
//       print('Attempting to load emotion_model.tflite from assets');
//       final interpreter = await Interpreter.fromAsset('emotion_model.tflite');
//       _isolateInterpreter = await IsolateInterpreter.create(address: interpreter.address);
//       setState(() {
//         _modelLoaded = true;
//         _errorMessage = '';
//       });
//       print('TFLite model loaded successfully with isolate');
//     } catch (e) {
//       print('Error loading model: $e');
//       setState(() {
//         _modelLoaded = false;
//         _errorMessage = 'Failed to load model: $e';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading model: $e')),
//       );
//     }
//   }

//   Future<void> _processImage(CameraImage image) async {
//     if (_isProcessing || _isolateInterpreter == null || !mounted || !_modelLoaded) {
//       _skippedFrames++;
//       print('Skipped frame $_skippedFrames: isProcessing=$_isProcessing, isolateInterpreter=${_isolateInterpreter != null}, mounted=$mounted, modelLoaded=$_modelLoaded');
//       return;
//     }
//     _frameCounter++;
//     if (_frameCounter % _skipFrameInterval != 0) {
//       _skippedFrames++;
//       print('Skipped frame $_skippedFrames due to adaptive skipping');
//       return;
//     }

//     _isProcessing = true;
//     final stopwatch = Stopwatch()..start();
//     try {
//       final img.Image? convertedImage = _convertCameraImage(image);
//       if (convertedImage == null) {
//         print('Error converting image');
//         return;
//       }

//       final img.Image grayscale = img.grayscale(convertedImage);
//       final inputImage = InputImage.fromBytes(
//         bytes: img.encodeJpg(grayscale),
//         metadata: InputImageMetadata(
//           size: Size(grayscale.width.toDouble(), grayscale.height.toDouble()),
//           rotation: InputImageRotation.rotation0deg,
//           format: InputImageFormat.nv21,
//           bytesPerRow: grayscale.width,
//         ),
//       );

//       final faces = await _faceDetector.processImage(inputImage);
//       if (faces.isEmpty) {
//         print('No faces detected in frame');
//         setState(() {
//           _currentEmotion = 'No Face Detected';
//         });
//         return;
//       }

//       for (final face in faces) {
//         final rect = face.boundingBox;
//         int x = rect.left.toInt();
//         int y = rect.top.toInt();
//         int w = rect.width.toInt();
//         int h = rect.height.toInt();
//         x = x.clamp(0, grayscale.width);
//         y = y.clamp(0, grayscale.height);
//         w = (x + w) > grayscale.width ? grayscale.width - x : w;
//         h = (y + h) > grayscale.height ? grayscale.height - y : h;

//         final faceImg = img.copyCrop(grayscale, x: x, y: y, width: w, height: h);
//         if (faceImg.width == 0 || faceImg.height == 0) {
//           print('Invalid face region');
//           continue;
//         }

//         final resized = img.copyResize(faceImg, width: 48, height: 48);
//         final input = Float32List(1 * 48 * 48 * 1);
//         final pixels = resized.getBytes();
//         for (int i = 0; i < pixels.length; i++) {
//           input[i] = pixels[i] / 255.0;
//         }
//         final inputReshaped = input.reshape([1, 48, 48, 1]);

//         final output = Float32List(1 * 7).reshape([1, 7]);
//         await _isolateInterpreter!.run(inputReshaped, output);

//         final emotionIndex = output[0].asMap().entries.reduce((a, b) => a.value > b.value ? a : b).key;
//         final emotion = _emotions[emotionIndex];
//         print('Predicted emotion: $emotion (scores: ${output[0]})');

//         setState(() {
//           _emotionCounts[emotion] = (_emotionCounts[emotion] ?? 0) + 1;
//           _currentEmotion = emotion;
//         });
//         print('Emotion counts: $_emotionCounts');
//       }
//       print('Frame processed in ${stopwatch.elapsedMilliseconds} ms');
//     } catch (e) {
//       print('Error processing image: $e');
//     } finally {
//       _isProcessing = false;
//       stopwatch.stop();
//     }
//   }

//   img.Image? _convertCameraImage(CameraImage image) {
//     try {
//       if (image.format.group == ImageFormatGroup.yuv420) {
//         final int width = image.width;
//         final int height = image.height;
//         final img.Image converted = img.Image(width: width, height: height);
//         final yPlane = image.planes[0].bytes;
//         final uPlane = image.planes[1].bytes;
//         final vPlane = image.planes[2].bytes;
//         final uvRowStride = image.planes[1].bytesPerRow;
//         final uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

//         for (int y = 0; y < height; y++) {
//           for (int x = 0; x < width; x++) {
//             final int yIndex = y * width + x;
//             final int uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

//             final int Y = yPlane[yIndex];
//             final int U = uPlane[uvIndex] - 128;
//             final int V = vPlane[uvIndex] - 128;

//             final int R = (Y + 1.13983 * V).round().clamp(0, 255);
//             final int G = (Y - 0.39465 * U - 0.58060 * V).round().clamp(0, 255);
//             final int B = (Y + 2.03211 * U).round().clamp(0, 255);

//             converted.setPixelRgb(x, y, R, G, B);
//           }
//         }
//         return converted;
//       } else if (image.format.group == ImageFormatGroup.bgra8888) {
//         return img.Image.fromBytes(
//           width: image.width,
//           height: image.height,
//           bytes: image.planes[0].bytes.buffer,
//           order: img.ChannelOrder.bgra,
//         );
//       }
//       print('Unsupported image format: ${image.format.group}');
//       return null;
//     } catch (e) {
//       print('Error converting CameraImage: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Emotion Detection'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           if (_controller != null && _controller!.value.isInitialized)
//             Expanded(
//               child: CameraPreview(_controller!),
//             )
//           else
//             const Expanded(
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text(
//                   _modelLoaded ? 'Current Emotion: $_currentEmotion' : 'Model Loading Failed',
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 if (_errorMessage.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       _errorMessage,
//                       style: const TextStyle(fontSize: 14, color: Colors.red),
//                     ),
//                   ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Emotion Counts: ${_emotionCounts.isEmpty ? 'None' : _emotionCounts.toString()}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   'Skipped Frames: $_skippedFrames',
//                   style: const TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _isolateInterpreter?.close();
//     _faceDetector.close();
//     super.dispose();
//   }
// }