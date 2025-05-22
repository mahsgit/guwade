import 'package:buddy/features/quiz/presentation/pages/quiz_page.dart';
import 'package:buddy/features/storytelling/domain/entities/vocabulary.dart';
import 'package:buddy/features/storytelling/presentation/bloc/storytelling_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  late FlutterTts _flutterTts;
  bool _isTtsInitialized = false;
  bool _isPlaying = false;
  final double _volume = 0.7;
  double _speechRate = 0.4;
  String _currentVoice = 'en-US';
  List<Map<String, dynamic>> _voices = [];

  List<String> _storyPages = [];
  List<Map<String, dynamic>> _contentPages = [];
  int _currentPageIndex = 0;

  String _currentWord = "";
  List<String> _currentPageWords = [];
  int _currentWordIndex = -1;

  double _fontSize = 24.0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initTts();
    _processStoryContent();
    context.read<StorytellingBloc>().add(LoadVocabulary());
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    try {
      final voices = await _flutterTts.getVoices;
      _voices = (voices ?? [])
          .where((v) => v['locale'].startsWith('en') || v['locale'].startsWith('es'))
          .toList();

      if (_voices.isNotEmpty) {
        await _flutterTts.setVoice({"name": _voices.first['name'], "locale": _currentVoice});
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

  int _findWordIndex(String word) {
    return _currentPageWords.indexWhere((w) => w.toLowerCase() == word.toLowerCase());
  }

  void _processStoryContent() {
    final sentences = widget.content.split(RegExp(r'(?<=[.!?])\s+'));
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
            icon: const Icon(Icons.download, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<StorytellingBloc, StorytellingState>(
        builder: (context, state) {
          if (state is VocabularyLoaded) {
            _contentPages = [];
            for (int i = 0; i < _storyPages.length; i++) {
              _contentPages.add({'type': 'story', 'content': _storyPages[i]});
            }
            // Add a single quiz page at the end if vocabulary exists
            final vocabForQuiz = _extractVocabulary(state.vocabulary);
            if (vocabForQuiz.isNotEmpty) {
              _contentPages.add({'type': 'quiz', 'vocabulary': vocabForQuiz});
            }
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: _contentPages.length,
            onPageChanged: _handlePageChange,
            itemBuilder: (context, index) {
              final page = _contentPages[index];
              return page['type'] == 'story'
                  ? _buildStoryPage(page['content'], index)
                  : _buildQuizPage(page['vocabulary'], index);
            },
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
                widget.imageUrl,
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
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
                        widget.title,
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

  Widget _buildQuizPage(List<Vocabulary> pageVocab, int index) {
    final totalPages = _contentPages.length;
    final currentPage = index + 1;

    return Stack(
      children: [
        QuizPage(
          vocabulary: pageVocab,
          onComplete: () {
            // Optionally handle what happens after quiz completion
            Navigator.pop(context); // Example: Navigate back after quiz
          },
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

  List<Vocabulary> _extractVocabulary(List<Vocabulary> allVocab) {
    // Extract all vocabulary words present in the entire story content
    final storyContent = _storyPages.join(' ').toLowerCase();
    return allVocab.where((v) => storyContent.contains(v.word.toLowerCase())).toList();
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
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
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

  Future<void> _setLanguage(String lang) async {
    await _flutterTts.setLanguage(lang);
    setState(() {
      _currentVoice = lang;
    });
    await _flutterTts.setVoice({"name": _voices.first['name'], "locale": _currentVoice});
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }
}