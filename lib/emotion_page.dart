 import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class EmotionCapturePage extends StatefulWidget {
  const EmotionCapturePage({super.key});

  @override
  _EmotionCapturePageState createState() => _EmotionCapturePageState();
}

class _EmotionCapturePageState extends State<EmotionCapturePage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCapturing = false;
  String responseText = "";

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isEmpty) {
      print("No cameras found");
      setState(() {
        responseText = "No cameras available on this device.";
      });
      return;
    }

    // Find the front-facing camera
    CameraDescription? frontCamera = cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () {
        print("No front camera found");
        setState(() {
          responseText = "No front camera available.";
        });
        return null; // Return null if no front camera is found
      },
    );

    if (frontCamera == null) {
      return; // Exit if no front camera is found
    }

    _cameraController = CameraController(frontCamera, ResolutionPreset.low);
    try {
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
      setState(() {
        responseText = "Error initializing camera: $e";
      });
    }
  }

  // Rest of the code remains unchanged
  Future<void> captureAndSendFrames() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() {
      isCapturing = true;
      responseText = "";
    });

    final List<XFile> capturedFrames = [];

    try {
      for (int i = 0; i < 30; i++) {
        XFile file = await _cameraController!.takePicture();
        capturedFrames.add(file);
        await Future.delayed(Duration(milliseconds: 100));
      }

      final response = await sendFramesToServer(capturedFrames);

      setState(() {
        responseText = response;
      });
    } catch (e) {
      setState(() {
        responseText = "Error: $e";
      });
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  Future<String> sendFramesToServer(List<XFile> frames) async {
    final uri = Uri.parse('https://emotion-backend-sh1h.onrender.com/predict');

    var request = http.MultipartRequest('POST', uri);

    for (var frame in frames) {
      var bytes = await frame.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'frames',
        bytes,
        filename: path.basename(frame.path),
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get prediction. Status: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: responseText.isNotEmpty
              ? Text(responseText)
              : CircularProgressIndicator(),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(title: Text("Capture & Send Frames")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
          SizedBox(height: 20),
          isCapturing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: captureAndSendFrames,
                  child: Text("Capture 30 Frames & Predict Emotion"),
                ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Text(responseText),
            ),
          )
        ],
      ),
    );
  }
}
