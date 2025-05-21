import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../presentation/bloc/story_bloc.dart';
import 'package:buddy/features/storytelling/domain/entities/vocabulary.dart';

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
  double _fontSize = 18.0;
  late FlutterTts _flutterTts;
  double _volume = 0.7;
  double _speechRate = 0.4;
  bool _isTtsInitialized = false;
  int _currentPage = 0;
  List<String> _pages = [];
  final PageController _pageController = PageController();
  String _currentWord = "";
  List<String> _currentPageWords = [];
  int _currentWordIndex = -1;
  List<dynamic> _storyAndQuizPages = [];
  List<Vocabulary> _vocabulary = [];
  int? _selectedQuizOption;
  bool? _quizAnsweredCorrectly;
  bool _quizTtsPlaying = false;
  int _currentQuizWordIndex = 0;
  String _currentQuizWord = '';

  @override
  void initState() {
    super.initState();
    _initTts();
    // Fetch story details from backend
    context.read<StoryBloc>().add(GetStoryDetailsEvent(widget.storyId));
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        progress = 1.0;
        _currentWordIndex = -1;
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
          if (_currentPageWords.isNotEmpty) {
            _currentWordIndex = _currentPageWords.indexOf(word);
            if (_currentWordIndex == -1) {
              for (int i = 0; i < _currentPageWords.length; i++) {
                if (_currentPageWords[i].contains(word)) {
                  _currentWordIndex = i;
                  break;
                }
              }
            }
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

  void _splitContentIntoPages(String content) {
    final lines = content.split(RegExp(r'(?<=\.)\s+'));
    List<String> pages = [];
    for (int i = 0; i < lines.length; i += 3) {
      pages.add(lines
          .sublist(i, (i + 3 < lines.length) ? i + 3 : lines.length)
          .join(' '));
    }
    _pages = pages;
    _storyAndQuizPages = [];
    for (int i = 0; i < _pages.length; i++) {
      _storyAndQuizPages.add({'type': 'story', 'content': _pages[i]});
      if ((i + 1) % 3 == 0 && i != 0) {
        final quizWords =
            _extractVocabularyFromPages(_pages.sublist(i - 2, i + 1));
        if (quizWords.isNotEmpty) {
          _storyAndQuizPages.add({'type': 'quiz', 'words': quizWords});
        }
      }
    }
  }

  List<Vocabulary> _extractVocabularyFromPages(List<String> pages) {
    return _vocabulary.take(2).toList();
  }

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

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _flutterTts.stop();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _flutterTts.stop();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _changeTextSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

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
                        max: 0.7,
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

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

  String _getSpeechRateLabel() {
    if (_speechRate <= 0.3) return 'Slow';
    if (_speechRate <= 0.5) return 'Normal';
    return 'Fast';
  }

  void _downloadStory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story downloaded for offline reading'),
        backgroundColor: Colors.teal,
      ),
    );
  }

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

  List<TextSpan> _buildHighlightedWordSpans() {
    List<TextSpan> spans = [];
    for (int i = 0; i < _currentPageWords.length; i++) {
      if (i == _currentWordIndex) {
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

  void _updateCurrentPageWords(String content) {
    final RegExp wordRegex = RegExp(r'\b\w+\b[.,;:!?]?');
    final Iterable<RegExpMatch> wordMatches = wordRegex.allMatches(content);
    _currentPageWords = wordMatches.map((match) => match.group(0)!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        if (state is StoryDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StoryDetailsLoaded) {
          final storyDetail = state.storyDetail;
          final content = storyDetail.pages.map((p) => p.content).join(' ');
          _splitContentIntoPages(content);
          return Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            body: PageView.builder(
              controller: _pageController,
              itemCount: _storyAndQuizPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  isPlaying = false;
                  progress = 0.0;
                  _currentWordIndex = -1;
                  if (_storyAndQuizPages[index]['type'] == 'story') {
                    _updateCurrentPageWords(
                        _storyAndQuizPages[index]['content']);
                  }
                });
                _flutterTts.stop();
              },
              itemBuilder: (context, index) {
                final page = _storyAndQuizPages[index];
                if (page['type'] == 'story') {
                  return _buildStoryPage(
                      page['content'],
                      storyDetail.story.title,
                      storyDetail.story.imageUrl ?? '');
                } else if (page['type'] == 'quiz') {
                  return _buildQuizPage(page['words']);
                }
                return const SizedBox();
              },
            ),
            bottomNavigationBar: _buildControls(),
          );
        } else if (state is StoryError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStoryPage(String content, String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/default_story.jpg')
                  as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildWordHighlightedText(content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizPage(List<Vocabulary> words) {
    if (words.isEmpty) {
      return const Center(
          child:
              Text('No quiz available', style: TextStyle(color: Colors.white)));
    }
    final random = Random();
    final vocab = words[random.nextInt(words.length)];
    final questionText = 'What does "${vocab.word}" mean?';
    final options = [
      vocab.synonym,
      ...words.where((w) => w.word != vocab.word).map((w) => w.synonym)
    ]..shuffle();
    final correctIndex = options.indexOf(vocab.synonym);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuizQuestionTTS(questionText),
          const SizedBox(height: 24),
          ...List.generate(options.length, (i) {
            final isSelected = _selectedQuizOption == i;
            final isCorrect = i == correctIndex;
            return GestureDetector(
              onTap: _quizAnsweredCorrectly == null
                  ? () => _onQuizOptionSelected(i, isCorrect)
                  : null,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: Colors.yellow, width: 3)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: _buildQuizOptionTTS(options[i], isSelected)),
                    if (_quizAnsweredCorrectly != null && isSelected)
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          if (_quizAnsweredCorrectly != null)
            Column(
              children: [
                Text(
                  _quizAnsweredCorrectly! ? 'Great job!' : 'Try again!',
                  style: TextStyle(
                    color: _quizAnsweredCorrectly! ? Colors.green : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedQuizOption = null;
                      _quizAnsweredCorrectly = null;
                    });
                    _nextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          if (_quizAnsweredCorrectly == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_quizTtsPlaying ? Icons.pause : Icons.volume_up),
                  onPressed: _quizTtsPlaying
                      ? _stopQuizTts
                      : () => _speakQuiz(questionText, options),
                  color: Colors.teal,
                  tooltip: 'Read Aloud',
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onQuizOptionSelected(int index, bool isCorrect) {
    setState(() {
      _selectedQuizOption = index;
      _quizAnsweredCorrectly = isCorrect;
    });
  }

  Widget _buildQuizQuestionTTS(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQuizOptionTTS(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _speakQuiz(String question, List<String> options) async {
    setState(() {
      _quizTtsPlaying = true;
    });
    await _flutterTts.speak(question);
    for (final option in options) {
      await _flutterTts.speak(option);
    }
    setState(() {
      _quizTtsPlaying = false;
    });
  }

  void _stopQuizTts() async {
    await _flutterTts.stop();
    setState(() {
      _quizTtsPlaying = false;
    });
  }

  Widget _buildControls() {
    return Container(
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
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showVoiceSettings,
            tooltip: 'Text Settings',
            color: Colors.black87,
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: _currentPage > 0 ? _previousPage : null,
            tooltip: 'Previous Page',
            color: _currentPage > 0 ? Colors.black87 : Colors.grey[400],
          ),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _isTtsInitialized ? _playPause : null,
            tooltip: isPlaying ? 'Pause' : 'Play',
            color: _isTtsInitialized ? Colors.black87 : Colors.grey[400],
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed:
                _currentPage < _storyAndQuizPages.length - 1 ? _nextPage : null,
            tooltip: 'Next Page',
            color: _currentPage < _storyAndQuizPages.length - 1
                ? Colors.black87
                : Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
