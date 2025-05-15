import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import '../../../../core/di/injection_container.dart';
import '../../presentation/bloc/story_bloc.dart';
import '../../domain/entities/story_detail.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;
  final String title;
  final String imageUrl;
  final String content;

  const StoryDetailPage({
    super.key,
    required this.storyId,
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  bool isPlaying = false;
  bool isBookmarked = false;
  double progress = 0.0;

  // Text size options
  double _fontSize = 18.0; // Larger default size for children
  // TTS related variables
  late FlutterTts _flutterTts;
  double _volume = 0.7; // Default volume (0.0 to 1.0)
  double _speechRate = 0.4; // Slower default speech rate for children
  bool _isTtsInitialized = false;
  // Page navigation
  int _currentPage = 0;
  late List<String> _pages;
  final PageController _pageController = PageController();

  // Text highlighting
  String _currentWord = "";
  List<String> _currentPageWords = [];
  int _currentWordIndex = -1;

  // Emotion detection
  late CameraController _cameraController;
  final List<XFile> _capturedImages = [];
  final int _maxImages = 15;
  Timer? _captureTimer;
  bool _processingEmotion = false;
  bool _cameraInitialized = false;
  bool _showCamera = false;

  // Current story data
  String _currentStoryId = '';
  String _currentTitle = '';
  String _currentImageUrl = '';
  String _currentContent = '';

  @override
  void initState() {
    super.initState();
    _currentStoryId = widget.storyId;
    _currentTitle = widget.title;
    _currentImageUrl = widget.imageUrl;
    _currentContent = widget.content;
    _initTts();
    _splitContentIntoPages();
    _initializeCamera();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    _captureTimer?.cancel();
    if (_cameraInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    try {
      final cameras = sl<List<CameraDescription>>();
      if (cameras.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      // Use front camera for face detection
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _cameraInitialized = true;
        });
        _startCapturingImages();
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // Start capturing images for emotion detection
  void _startCapturingImages() {
    if (!_cameraInitialized) return;

    _captureTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_capturedImages.length >= _maxImages) {
        _captureTimer?.cancel();
        if (!_processingEmotion) {
          _processEmotions();
        }
        return;
      }

      try {
        if (!_cameraController.value.isInitialized) {
          return;
        }

        final XFile image = await _cameraController.takePicture();

        setState(() {
          _capturedImages.add(image);
        });

        // If we have enough images, process emotions
        if (_capturedImages.length >= _maxImages) {
          _captureTimer?.cancel();
          if (!_processingEmotion) {
            _processEmotions();
          }
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    });
  }

  // Process captured images for emotion detection
  void _processEmotions() {
    setState(() {
      _processingEmotion = true;
    });

    try {
      // Send images to emotion detection bloc
      context.read<StoryBloc>().add(
            DetectEmotionEvent(_capturedImages),
          );
    } catch (e) {
      debugPrint('Error processing emotions: $e');
    }

    // Reset for next batch
    _capturedImages.clear();

    // Restart image capture after processing
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _processingEmotion = false;
      });
      _startCapturingImages();
    });
  }

  // Show dialog to change story if user is not interested
  void _showChangeStoryDialog(BuildContext context, String storyId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Change Story?'),
          content: const Text(
              'It seems you might not be interested in this story. Would you like to read a different one?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No, continue'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Yes, change story'),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();

                // Then dispatch the event to change the story
                print(
                    "Dispatching GetNextStoryEvent with ID: $_currentStoryId");
                context
                    .read<StoryBloc>()
                    .add(GetNextStoryEvent(_currentStoryId));
              },
            ),
          ],
        );
      },
    );
  }

  // Update story content with new story
  void _updateStoryContent(StoryDetail storyDetail) {
    setState(() {
      // Access the ID through the story property
      _currentStoryId = storyDetail.story.id;
      _currentTitle = storyDetail.story.title;

      // Assuming these are properties of the Story object or can be derived from pages
      _currentImageUrl =
          storyDetail.story.imageUrl ?? 'assets/images/default_story.jpg';

      // For content, we might need to concatenate page contents or use adapted content
      if (storyDetail.pages.isNotEmpty) {
        _currentContent =
            storyDetail.pages.map((page) => page.content).join('\n\n');
      } else if (storyDetail.adaptedContent.containsKey('neutral')) {
        _currentContent = storyDetail.adaptedContent['neutral'] ?? '';
      } else {
        _currentContent = 'No content available for this story.';
      }

      // Reset reading state
      isPlaying = false;
      progress = 0.0;
      _currentPage = 0;
      _currentWordIndex = -1;

      // Re-split content for the new story
      _splitContentIntoPages();

      // Reset page controller
      _pageController.jumpToPage(0);
    });

    // Stop any ongoing TTS
    _flutterTts.stop();
  }

  // Initialize Text-to-Speech
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        progress = 1.0; // Set to complete
        _currentWordIndex = -1;

        // Auto-advance to next page after a short delay
        if (_currentPage < _pages.length - 1) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
      });
    });

    _flutterTts.setProgressHandler(
        (String text, int startOffset, int endOffset, String word) {
      if (mounted) {
        setState(() {
          _currentWord = word;

          // Find the word index in the current page
          if (_currentPageWords.isNotEmpty) {
            // Try to find the exact word
            _currentWordIndex = _currentPageWords.indexOf(word);

            // If not found, try to find a word that contains this word
            if (_currentWordIndex == -1) {
              for (int i = 0; i < _currentPageWords.length; i++) {
                if (_currentPageWords[i].contains(word)) {
                  _currentWordIndex = i;
                  break;
                }
              }
            }

            // If still not found, use approximate position
            if (_currentWordIndex == -1 && _currentPageWords.isNotEmpty) {
              _currentWordIndex =
                  ((startOffset / text.length) * _currentPageWords.length)
                      .floor();
              _currentWordIndex =
                  _currentWordIndex.clamp(0, _currentPageWords.length - 1);
            }
          }

          if (_pages[_currentPage].isNotEmpty) {
            progress = endOffset / text.length;
          }
        });
      }
    });

    setState(() {
      _isTtsInitialized = true;
    });
  }

  // Split content into smaller pages for children (2 sentences per page)
  void _splitContentIntoPages() {
    // First split by sentences
    final RegExp sentenceRegex = RegExp(r'[^.!?]+[.!?]');
    final Iterable<RegExpMatch> sentenceMatches =
        sentenceRegex.allMatches(_currentContent);
    final List<String> sentences =
        sentenceMatches.map((match) => match.group(0)!.trim()).toList();

    _pages = [];

    // Group into pages of 2 sentences or less
    for (int i = 0; i < sentences.length; i += 2) {
      final int end = (i + 2 < sentences.length) ? i + 2 : sentences.length;
      final String page = sentences.sublist(i, end).join(' ');
      _pages.add(page);
    }

    // Ensure we have at least one page
    if (_pages.isEmpty) {
      _pages = ['No content available'];
    }

    // Pre-split the first page into words
    if (_pages.isNotEmpty) {
      _updateCurrentPageWords();
    }
  }

  // Update the words list for the current page
  void _updateCurrentPageWords() {
    // Split by words, keeping punctuation attached to words
    final RegExp wordRegex = RegExp(r'\b\w+\b[.,;:!?]?');
    final Iterable<RegExpMatch> wordMatches =
        wordRegex.allMatches(_pages[_currentPage]);
    _currentPageWords = wordMatches.map((match) => match.group(0)!).toList();
  }

  // Play or pause the TTS
  Future<void> _playPause() async {
    if (!_isTtsInitialized) return;

    if (isPlaying) {
      await _flutterTts.stop();
      setState(() {
        isPlaying = false;
        _currentWordIndex = -1;
      });
    } else {
      setState(() {
        isPlaying = true;
        _currentWordIndex = -1;
        progress = 0.0;
      });
      await _flutterTts.speak(_pages[_currentPage]);
    }
  }

  // Go to next page
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _flutterTts.stop();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Go to previous page
  void _previousPage() {
    if (_currentPage > 0) {
      _flutterTts.stop();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Change text size
  void _changeTextSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  // Show voice settings dialog
  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Voice Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Voice Speed
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text(
                      'Speed',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Expanded(
                      child: Slider(
                        value: _speechRate,
                        min: 0.1,
                        max: 0.7, // Lower max speed for children
                        divisions: 6,
                        activeColor: Colors.tealAccent,
                        inactiveColor: Colors.grey[700],
                        label: _getSpeechRateLabel(),
                        onChanged: (value) async {
                          setModalState(() {
                            _speechRate = value;
                          });
                          setState(() {
                            _speechRate = value;
                          });
                          await _flutterTts.setSpeechRate(value);
                          if (isPlaying) {
                            await _flutterTts.stop();
                            await _flutterTts.speak(_pages[_currentPage]);
                          }
                        },
                      ),
                    ),
                    Text(
                      _getSpeechRateLabel(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                // Volume
                Row(
                  children: [
                    const Icon(Icons.volume_up, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text(
                      'Volume',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: Colors.tealAccent,
                        inactiveColor: Colors.grey[700],
                        label: '${(_volume * 100).round()}%',
                        onChanged: (value) async {
                          setModalState(() {
                            _volume = value;
                          });
                          setState(() {
                            _volume = value;
                          });
                          await _flutterTts.setVolume(value);
                        },
                      ),
                    ),
                    Text(
                      '${(_volume * 100).round()}%',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                // Text Size
                Row(
                  children: [
                    const Icon(Icons.text_fields, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text(
                      'Text Size',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 20),
                    _textSizeButton('S', 16.0),
                    const SizedBox(width: 10),
                    _textSizeButton('M', 18.0),
                    const SizedBox(width: 10),
                    _textSizeButton('L', 22.0),
                  ],
                ),

                // Camera toggle
                Row(
                  children: [
                    const Icon(Icons.camera_front, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text(
                      'Show Camera',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 20),
                    Switch(
                      value: _showCamera,
                      activeColor: Colors.tealAccent,
                      onChanged: (value) {
                        setModalState(() {
                          _showCamera = value;
                        });
                        setState(() {
                          _showCamera = value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to create text size buttons
  Widget _textSizeButton(String label, double size) {
    final isSelected = _fontSize == size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.tealAccent : Colors.grey[800],
        foregroundColor: isSelected ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      ),
      onPressed: () {
        setState(() {
          _fontSize = size;
        });
      },
      child: Text(label),
    );
  }

  // Get speech rate label
  String _getSpeechRateLabel() {
    if (_speechRate <= 0.3) return 'Slow';
    if (_speechRate <= 0.5) return 'Normal';
    return 'Fast';
  }

  // Download the story
  void _downloadStory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story downloaded for offline reading'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Build word-by-word highlighted text
  Widget _buildWordHighlightedText(String text) {
    if (!isPlaying || _currentWordIndex < 0 || _currentPageWords.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: _fontSize,
          height: 1.5,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: _buildHighlightedWordSpans(),
      ),
    );
  }

  // Build text spans with the current word highlighted
  List<TextSpan> _buildHighlightedWordSpans() {
    List<TextSpan> spans = [];

    for (int i = 0; i < _currentPageWords.length; i++) {
      if (i == _currentWordIndex) {
        // Highlighted current word
        spans.add(
          TextSpan(
            text: "${_currentPageWords[i]} ",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: _fontSize,
              height: 1.5,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black45,
            ),
          ),
        );
      } else {
        // Regular word
        spans.add(
          TextSpan(
            text: "${_currentPageWords[i]} ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: _fontSize,
              height: 1.5,
            ),
          ),
        );
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state is EmotionDetected && !state.isInterested) {
          _showChangeStoryDialog(context, _currentStoryId);
        } else if (state is NextStoryLoaded) {
          // Update the story content when a new story is loaded
          _updateStoryContent(state.storyDetail);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_stories,
              color: Colors.white,
              size: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: _downloadStory,
            ),
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Story image with gradient overlay
            Expanded(
              child: Stack(
                children: [
                  // Full-screen image
                  Image.asset(
                    _currentImageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Gradient overlay from bottom to top
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.8),
                          Colors.black,
                        ],
                        stops: const [0.5, 0.7, 0.8, 1.0],
                      ),
                    ),
                  ),

                  // Camera preview (if enabled)
                  if (_showCamera && _cameraInitialized)
                    Positioned(
                      top: 80,
                      right: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: CameraPreview(_cameraController),
                        ),
                      ),
                    ),

                  // Emotion detection status
                  if (_processingEmotion)
                    Positioned(
                      top: 240,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.tealAccent),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Analyzing...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Content positioned at the bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            _currentTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Page indicator for kids
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentPage
                                      ? Colors.tealAccent
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Story content with word highlighting
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _pages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                  isPlaying = false;
                                  progress = 0.0;
                                  _currentWordIndex = -1;
                                  _updateCurrentPageWords();
                                });
                                _flutterTts.stop();
                              },
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[800]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: index == _currentPage
                                        ? _buildWordHighlightedText(
                                            _pages[index])
                                        : Text(
                                            _pages[index],
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: _fontSize,
                                              height: 1.5,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Audio player controls
            Column(
              children: [
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background track
                      Container(
                        height: 4.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),

                      // Progress track
                      Positioned(
                        left: 0,
                        child: Container(
                          height: 4.0,
                          width: (MediaQuery.of(context).size.width - 40) *
                              progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.yellow, Colors.orange],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),

                      // Progress indicator
                      Positioned(
                        left: (MediaQuery.of(context).size.width - 40) *
                                progress -
                            8,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            final RenderBox box =
                                context.findRenderObject() as RenderBox;
                            final Offset localPosition =
                                box.globalToLocal(details.globalPosition);
                            final double newProgress = (localPosition.dx - 20) /
                                (MediaQuery.of(context).size.width - 40);

                            if (newProgress >= 0 && newProgress <= 1.0) {
                              setState(() {
                                progress = newProgress;
                                // Calculate approximate word position
                                if (_currentPageWords.isNotEmpty) {
                                  _currentWordIndex =
                                      (newProgress * _currentPageWords.length)
                                          .floor();
                                  _currentWordIndex = _currentWordIndex.clamp(
                                      0, _currentPageWords.length - 1);
                                }
                              });

                              // If playing, stop and restart from new position
                              if (isPlaying) {
                                _flutterTts.stop();
                                final int wordIndex =
                                    (newProgress * _currentPageWords.length)
                                        .floor();
                                if (wordIndex < _currentPageWords.length) {
                                  // Create a substring from the selected word to the end
                                  final String remainingText = _currentPageWords
                                      .sublist(wordIndex)
                                      .join(' ');
                                  _flutterTts.speak(remainingText);
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 16.0,
                            width: 16.0,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Control buttons
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.teal[100]!,
                        Colors.teal[200]!,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Text mode button
                      IconButton(
                        icon: const Icon(Icons.text_fields),
                        onPressed: _showVoiceSettings,
                        tooltip: 'Text Settings',
                        color: Colors.black87,
                      ),

                      // Previous button
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _currentPage > 0 ? _previousPage : null,
                        tooltip: 'Previous Page',
                        color: _currentPage > 0
                            ? Colors.black87
                            : Colors.grey[400],
                      ),

                      // Play/Pause button
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _isTtsInitialized ? _playPause : null,
                        tooltip: isPlaying ? 'Pause' : 'Play',
                        color: _isTtsInitialized
                            ? Colors.black87
                            : Colors.grey[400],
                      ),

                      // Next button
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed:
                            _currentPage < _pages.length - 1 ? _nextPage : null,
                        tooltip: 'Next Page',
                        color: _currentPage < _pages.length - 1
                            ? Colors.black87
                            : Colors.grey[400],
                      ),

                      // Camera button
                      IconButton(
                        icon: const Icon(Icons.camera_front),
                        onPressed: () {
                          setState(() {
                            _showCamera = !_showCamera;
                          });
                        },
                        tooltip: 'Toggle Camera',
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
