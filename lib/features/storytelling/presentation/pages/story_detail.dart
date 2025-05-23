import 'dart:async';
import 'dart:typed_data';
import 'package:buddy/features/science/presentation/pages/quiz_page.dart';
import 'package:buddy/features/storytelling/domain/entities/story.dart';
import 'package:buddy/features/storytelling/domain/entities/vocabulary.dart';
import 'package:buddy/features/storytelling/presentation/bloc/storytelling_bloc.dart';
import 'package:buddy/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StoryDetailPage extends StatefulWidget {
  final Story story;

  const StoryDetailPage({
    super.key,
    required this.story,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late FlutterTts _flutterTts;
  bool _isTtsInitialized = false;
  bool _isPlaying = false;
  final double _volume = 0.7;
  double _speechRate = 0.4;
  String _currentVoice = 'en-US';
  List<Map<String, dynamic>> _voices = [];
  String _selectedGender = 'female';
  CameraController? _cameraController;
  bool _isCapturing = false;
  String _emotion = "Detecting...";
  Timer? _emotionTimer;

  List<String> _storyPages = [];
  List<Map<String, dynamic>> _contentPages = [];
  int _currentPageIndex = 0;
  int _correctAnswers = 0;
  late Story _currentStory;

  String _currentWord = "";
  List<String> _currentPageWords = [];
  int _currentWordIndex = -1;
  double _fontSize = 24.0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentStory = widget.story;
    _initTts();
    _initCamera();
    _processStoryContent();
    context.read<StorytellingBloc>().add(LoadVocabulary());
    _startEmotionCapture();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    try {
      final voices = await _flutterTts.getVoices;
      _voices = (voices ?? [])
          .where((v) => v['locale'].startsWith('en') || v['locale'].startsWith('es'))
          .toList();
      final femaleVoices = _voices.where((v) => v['name']?.toLowerCase().contains('female') ?? false).toList();
      final maleVoices = _voices.where((v) => v['name']?.toLowerCase().contains('male') ?? false).toList();
      final availableVoices = femaleVoices.isNotEmpty ? femaleVoices : maleVoices.isNotEmpty ? maleVoices : _voices;

      if (availableVoices.isNotEmpty) {
        await _flutterTts.setVoice({"name": availableVoices.first['name'], "locale": _currentVoice});
      }
    } catch (e) {
      print("Error loading voices: $e");
    }

    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(1.2);

    _flutterTts.setCompletionHandler(() {
      setState(() => _isPlaying = false);
      if (_currentPageIndex < _contentPages.length - 1 && _contentPages[_currentPageIndex]['type'] == 'story') {
        _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });

    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWord = word;
        _currentWordIndex = _findWordIndex(word);
      });
    });

    setState(() => _isTtsInitialized = true);
  }

  Future<void> _initCamera() async {
    if (cameras.isEmpty) {
      print("No cameras found");
      setState(() => _emotion = "No Camera");
      return;
    }
    _cameraController = CameraController(cameras.first, ResolutionPreset.low);
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  void _startEmotionCapture() {
    _emotionTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isCapturing && _cameraController != null && _cameraController!.value.isInitialized) {
        await _captureAndSendFrames();
      }
    });
  }

  Future<void> _captureAndSendFrames() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() {
      _isCapturing = true;
      _emotion = "Capturing...";
    });

    final List<XFile> capturedFrames = [];

    try {
      for (int i = 0; i < 15; i++) {
        XFile file = await _cameraController!.takePicture();
        capturedFrames.add(file);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final bytesList = await Future.wait(capturedFrames.map((file) => file.readAsBytes()));
      context.read<StorytellingBloc>().add(DetectEmotion(frames: bytesList, storyId: _currentStory.id));
    } catch (e) {
      setState(() {
        _emotion = "Error: $e";
      });
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  int _findWordIndex(String word) {
    return _currentPageWords.indexWhere((w) => w.toLowerCase() == word.toLowerCase());
  }

  void _processStoryContent() {
    final sentences = _currentStory.storyBody.split(RegExp(r'(?<=[.!?])\s+'));
    _storyPages = [];

    String currentPage = '';
    for (var sentence in sentences) {
      if ((currentPage + sentence).split(' ').length <= 20) {
        currentPage += '$sentence ';
      } else {
        _storyPages.add(currentPage.trim());
        currentPage = '$sentence ';
      }
    }
    if (currentPage.isNotEmpty) _storyPages.add(currentPage.trim());

    _contentPages = [];
    for (int i = 0; i < _storyPages.length; i++) {
      _contentPages.add({'type': 'story', 'content': _storyPages[i]});
    }

    if (_storyPages.isNotEmpty) {
      _currentPageWords = _storyPages[0].split(' ');
    }
  }

  Future<void> _playPause() async {
    if (!_isTtsInitialized || _contentPages[_currentPageIndex]['type'] != 'story') return;

    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      await _flutterTts.speak(_contentPages[_currentPageIndex]['content']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate, color: Colors.white, size: 30),
            onPressed: _showLanguageDialog,
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white, size: 30),
            onPressed: _showVoiceDialog,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<StorytellingBloc, StorytellingState>(
        listener: (context, state) {
          if (state is EmotionDetected && state.emotion == 'sad') {
            _showBoredDialog();
          } else if (state is StoryUpdated) {
            setState(() {
              _currentStory = state.story;
              _currentPageIndex = 0;
              _processStoryContent();
            });
          }
        },
        builder: (context, state) {
          if (state is VocabularyLoaded) {
            _contentPages = [];
            for (int i = 0; i < _storyPages.length; i++) {
              _contentPages.add({'type': 'story', 'content': _storyPages[i]});
              final vocab = _extractVocabularyFromPage(state.vocabulary, i);
              if (i > 0 && vocab.isNotEmpty && !_contentPages.any((p) => p['type'] == 'quiz')) {
                _contentPages.add({'type': 'quiz', 'vocabulary': vocab, 'prevPageIndex': i - 1});
              }
            }
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _contentPages.length,
                onPageChanged: _handlePageChange,
                itemBuilder: (context, index) {
                  final page = _contentPages[index];
                  return page['type'] == 'story'
                      ? _buildStoryPage(page['content'], index)
                      : _buildQuizPage(page['vocabulary'], index, page['prevPageIndex']);
                },
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _cameraController == null || !_cameraController!.value.isInitialized
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            AspectRatio(
                              aspectRatio: _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            ),
                            Text(
                              _emotion,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildControls(),
    );
  }

  Widget _buildStoryPage(String content, int index) {
    final totalPages = _contentPages.length;
    final currentPage = index + 1;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Image.network(
                _currentStory.imageUrl ?? 'https://example.com/placeholder.jpg',
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/cinderella.png',
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentStory.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _isPlaying
                          ? _buildHighlightedText(content)
                          : Text(
                              content,
                              style: TextStyle(
                                fontSize: _fontSize,
                                color: Colors.white,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Page $currentPage out of $totalPages',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'ComicNeue',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedText(String content) {
    final words = content.split(' ');
    return Wrap(
      spacing: 4,
      children: words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        return Text(
          '$word ',
          style: TextStyle(
            fontSize: _fontSize,
            fontFamily: 'ComicNeue',
            color: index == _currentWordIndex ? Colors.greenAccent : Colors.white,
            fontWeight: index == _currentWordIndex ? FontWeight.bold : FontWeight.normal,
            backgroundColor: index == _currentWordIndex ? Colors.yellow.withOpacity(0.5) : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizPage(List<Vocabulary> pageVocab, int index, int prevPageIndex) {
    final totalPages = _contentPages.length;
    final currentPage = index + 1;

    return Stack(
      children: [
        QuizPage(topic: '',
          // vocabulary: pageVocab,
          // onComplete: () {
          //   if (_currentPageIndex == _contentPages.length - 1) {
          //     _showAchievementDialog();
          //   } else {
          //     _pageController.nextPage(
          //       duration: const Duration(milliseconds: 500),
          //       curve: Curves.easeInOut,
          //     );
          //   }
          // },
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Page $currentPage out of $totalPages',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'ComicNeue',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Vocabulary> _extractVocabularyFromPage(List<Vocabulary> allVocab, int pageIndex) {
    if (pageIndex >= _storyPages.length) return [];
    final pageContent = _storyPages[pageIndex].toLowerCase();
    return allVocab.where((v) => pageContent.contains(v.word.toLowerCase())).toList();
  }

  void _handlePageChange(int index) async {
    await _flutterTts.stop();
    setState(() {
      _currentPageIndex = index;
      _isPlaying = false;
      _currentWordIndex = -1;
      if (_contentPages[index]['type'] == 'story') {
        _currentPageWords = _contentPages[index]['content'].split(' ');
      }
    });
    if (_isTtsInitialized && _contentPages[index]['type'] == 'story') {
      setState(() => _isPlaying = true);
      await _flutterTts.speak(_contentPages[index]['content']);
    }
  }

  Widget _buildControls() {
    final isFirstPage = _currentPageIndex == 0;
    final isLastPage = _currentPageIndex == _contentPages.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.text_fields, color: Colors.white, size: 30),
            onPressed: _showTextSettings,
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 30),
            onPressed: isFirstPage
                ? null
                : () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
              size: 40,
            ),
            onPressed: _playPause,
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
            onPressed: isLastPage
                ? null
                : () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
          ),
          IconButton(
            icon: const Icon(Icons.speed, color: Colors.white, size: 30),
            onPressed: _showSpeedSettings,
          ),
        ],
      ),
    );
  }

  void _showTextSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Text Size',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: DropdownButton<double>(
          value: _fontSize,
          items: [20.0, 24.0, 28.0, 32.0]
              .map((size) => DropdownMenuItem(
                    value: size,
                    child: Text('${size.toInt()}pt', style: const TextStyle(fontFamily: 'ComicNeue')),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _fontSize = value!),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 20, fontFamily: 'ComicNeue', color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showSpeedSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Reading Speed',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _speechRate,
              min: 0.3,
              max: 0.6,
              divisions: 3,
              activeColor: Colors.greenAccent,
              onChanged: (value) {
                setState(() => _speechRate = value);
                _flutterTts.setSpeechRate(value);
              },
            ),
            Text(
              'Speed: ${(_speechRate * 10).round()}/6',
              style: const TextStyle(fontSize: 18, fontFamily: 'ComicNeue'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 20, fontFamily: 'ComicNeue', color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Pick a Language!',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English', style: TextStyle(fontFamily: 'ComicNeue')),
              onTap: () => _setLanguage('en-US'),
            ),
            ListTile(
              title: const Text('Spanish', style: TextStyle(fontFamily: 'ComicNeue')),
              onTap: () => _setLanguage('es-ES'),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Select Voice',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Female', style: TextStyle(fontFamily: 'ComicNeue')),
              onTap: () {
                _setVoiceGender('female');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Male', style: TextStyle(fontFamily: 'ComicNeue')),
              onTap: () {
                _setVoiceGender('male');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBoredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Are you bored?',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: const Text(
          'You seem sad. Would you like to switch to a new story?',
          style: TextStyle(fontSize: 18, fontFamily: 'ComicNeue'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No',
              style: TextStyle(fontSize: 20, fontFamily: 'ComicNeue', color: Colors.blueAccent),
            ),
          ),


          TextButton(
            onPressed: () {
              context.read<StorytellingBloc>().add(ChangeStory(storyId: _currentStory.id));
              Navigator.pop(context);
            },
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 20, fontFamily: 'ComicNeue', color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setLanguage(String lang) async {
    await _flutterTts.setLanguage(lang);
    setState(() {
      _currentVoice = lang;
    });
    await _setVoiceGender(_selectedGender);
    Navigator.pop(context);
  }

  Future<void> _setVoiceGender(String gender) async {
    _selectedGender = gender;
    final voices = _voices.where((v) => v['locale'] == _currentVoice).toList();
    final genderVoices = gender == 'female'
        ? voices.where((v) => v['name']?.toLowerCase().contains('female') ?? false).toList()
        : voices.where((v) => v['name']?.toLowerCase().contains('male') ?? false).toList();
    final selectedVoice = genderVoices.isNotEmpty ? genderVoices.first : voices.isNotEmpty ? voices.first : null;
    if (selectedVoice != null) {
      await _flutterTts.setVoice({"name": selectedVoice['name'], "locale": _currentVoice});
    }
  }

  void _showAchievementDialog() {
    final totalVocab = _extractVocabularyFromAllPages(context.read<StorytellingBloc>().state).length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Achievement Unlocked!',
          style: TextStyle(fontSize: 26, fontFamily: 'ComicNeue', color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You answered $_correctAnswers out of $totalVocab vocabulary words correctly!',
              style: const TextStyle(fontSize: 18, fontFamily: 'ComicNeue'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/trophy.png',
              height: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 20, fontFamily: 'ComicNeue', color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  List<Vocabulary> _extractVocabularyFromAllPages(StorytellingState state) {
    if (state is VocabularyLoaded) {
      final storyContent = _storyPages.join(' ').toLowerCase();
      return state.vocabulary.where((v) => storyContent.contains(v.word.toLowerCase())).toList();
    }
    return [];
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _cameraController?.dispose();
    _emotionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}