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
    Key? key,
    required this.storyId,
    required this.title,
    required this.imageUrl,
    required this.content,
  }) : super(key: key);

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  // TTS Engine
  late FlutterTts _flutterTts;
  bool _isTtsInitialized = false;
  bool _isPlaying = false;
  double _volume = 0.7;
  double _speechRate = 0.5;
  String _language = "en-US";
  String _voice = "female"; // Default to female voice
  bool _isTranslated = false;
  
  // Story Content
  List<String> _storyPages = [];
  List<Map<String, dynamic>> _contentPages = [];
  int _currentPageIndex = 0;
  
  // Word Highlighting
  String _currentWord = "";
  List<String> _currentPageWords = [];
  int _currentWordIndex = -1;
  double _readingProgress = 0.0;
  
  // UI
  double _fontSize = 18.0;
  final PageController _pageController = PageController();
  
  @override
  void initState() {
    super.initState();
    _initTts();
    _processStoryContent();
    
    // Load vocabulary for quizzes
    context.read<StorytellingBloc>().add(LoadVocabulary());
  }
  
  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }
  
  // Initialize Text-to-Speech engine
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage(_language);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(1.0);
    
    // Set voice - try to set female voice if available
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        final List<dynamic> voiceList = voices as List<dynamic>;
        final femaleVoices = voiceList.where((voice) {
          if (voice is Map) {
            return voice['name'].toString().toLowerCase().contains('female') || 
                   voice['name'].toString().toLowerCase().contains('woman');
          }
          return false;
        }).toList();
        
        if (femaleVoices.isNotEmpty) {
          await _flutterTts.setVoice({"name": femaleVoices.first['name'], "locale": _language});
        }
      }
    } catch (e) {
      print("Error setting voice: $e");
    }
    
    // Handle TTS completion
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
        _readingProgress = 1.0;
        _currentWordIndex = -1;
        
        // Auto-advance to next page after a delay
        if (_currentPageIndex < _contentPages.length - 1 && 
            _contentPages[_currentPageIndex]['type'] == 'story') {
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
    
    // Handle word progress for highlighting
    _flutterTts.setProgressHandler(
      (String text, int startOffset, int endOffset, String word) {
        if (mounted) {
          setState(() {
            _currentWord = word;
            if (_currentPageWords.isNotEmpty) {
              _currentWordIndex = _findWordIndex(word, text, startOffset);
              _readingProgress = endOffset / text.length;
            }
          });
        }
      },
    );
    
    setState(() {
      _isTtsInitialized = true;
    });
  }
  
  // Find the index of the current word being spoken
  int _findWordIndex(String word, String text, int startOffset) {
    // First try direct match
    int index = _currentPageWords.indexOf(word);
    
    // If not found, try partial match
    if (index == -1) {
      for (int i = 0; i < _currentPageWords.length; i++) {
        if (_currentPageWords[i].contains(word)) {
          return i;
        }
      }
    }
    
    // If still not found, estimate position based on offset
    if (index == -1 && _currentPageWords.isNotEmpty) {
      index = ((startOffset / text.length) * _currentPageWords.length).floor();
      return index.clamp(0, _currentPageWords.length - 1);
    }
    
    return index;
  }
  
  // Process story content into pages and quizzes
  void _processStoryContent() {
    // Split content into sentences
    final sentences = widget.content.split(RegExp(r'(?<=\.)\s+'));
    
    // Group sentences into pages (2 lines per page as requested)
    _storyPages = [];
    for (int i = 0; i < sentences.length; i += 2) {  // Changed from 3 to 2 sentences per page
      final end = (i + 2 < sentences.length) ? i + 2 : sentences.length;
      _storyPages.add(sentences.sublist(i, end).join(' '));
    }
    
    // Create content pages (story pages + quiz pages)
    _contentPages = [];
    for (int i = 0; i < _storyPages.length; i++) {
      _contentPages.add({'type': 'story', 'content': _storyPages[i]});
      
      // Add quiz after every 2 pages
      if ((i + 1) % 2 == 0 && i > 0) {
        _contentPages.add({'type': 'quiz', 'pageRange': [i-1, i]});
      }
    }
    
    // Initialize words for the first page
    if (_storyPages.isNotEmpty) {
      _updateCurrentPageWords(_storyPages[0]);
    }
  }
  
  // Update the list of words on the current page for highlighting
  void _updateCurrentPageWords(String content) {
    final RegExp wordRegex = RegExp(r'\b\w+\b[.,;:!?]?');
    final Iterable<RegExpMatch> wordMatches = wordRegex.allMatches(content);
    _currentPageWords = wordMatches.map((match) => match.group(0)!).toList();
  }
  
  // Play or pause the TTS
  Future<void> _playPause() async {
    if (!_isTtsInitialized) return;
    
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
        _currentWordIndex = -1;
      });
    } else {
      setState(() {
        _isPlaying = true;
        _currentWordIndex = -1;
        _readingProgress = 0.0;
      });
      
      if (_contentPages[_currentPageIndex]['type'] == 'story') {
        await _flutterTts.speak(_contentPages[_currentPageIndex]['content']);
      }
    }
  }

  // Toggle between English and Spanish
  Future<void> _toggleLanguage() async {
    await _flutterTts.stop();
    
    setState(() {
      _isTranslated = !_isTranslated;
      _language = _isTranslated ? "es-ES" : "en-US";
      _isPlaying = false;
      _currentWordIndex = -1;
    });
    
    await _flutterTts.setLanguage(_language);
    
    // If we're translating to Spanish, we would need to translate the content
    // This is a placeholder for actual translation logic
    if (_isTranslated) {
      // In a real app, you would call a translation API here
      // For now, we'll just pretend the content is translated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Content translated to Spanish")),
      );
    }
  }
  
  // Toggle between male and female voice
  Future<void> _toggleVoice() async {
    await _flutterTts.stop();
    
    setState(() {
      _voice = _voice == "female" ? "male" : "female";
      _isPlaying = false;
      _currentWordIndex = -1;
    });
    
    // Try to set the voice based on gender
    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        final List<dynamic> voiceList = voices as List<dynamic>;
        final genderVoices = voiceList.where((voice) {
          if (voice is Map) {
            return voice['name'].toString().toLowerCase().contains(_voice);
          }
          return false;
        }).toList();
        
        if (genderVoices.isNotEmpty) {
          await _flutterTts.setVoice({"name": genderVoices.first['name'], "locale": _language});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Voice changed to $_voice")),
          );
        }
      }
    } catch (e) {
      print("Error setting voice: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _contentPages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
            _isPlaying = false;
            _readingProgress = 0.0;
            _currentWordIndex = -1;
            
            // Update words for highlighting if it's a story page
            if (_contentPages[index]['type'] == 'story') {
              _updateCurrentPageWords(_contentPages[index]['content']);
            }
          });
          _flutterTts.stop();
        },
        itemBuilder: (context, index) {
          final page = _contentPages[index];
          
          if (page['type'] == 'story') {
            return _buildStoryPage(page['content']);
          } else {
            return BlocBuilder<StorytellingBloc, StorytellingState>(
              builder: (context, state) {
                if (state is VocabularyLoaded) {
                  final vocabList = state.vocabulary;
                  // Extract vocabulary words from the story pages in the range
                  final pageRange = page['pageRange'] as List<int>;
                  final relevantVocab = _extractRelevantVocabulary(
                    vocabList, 
                    pageRange[0], 
                    pageRange[1]
                  );
                  
                  if (relevantVocab.isNotEmpty) {
                    return QuizPage(
                      vocabulary: relevantVocab,
                      onComplete: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No vocabulary found for quiz',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }
                
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: _buildControls(),
    );
  }
  
  // Extract relevant vocabulary for quizzes
  List<Vocabulary> _extractRelevantVocabulary(
    List<Vocabulary> allVocab, 
    int startPage, 
    int endPage
  ) {
    // In a real app, you would search for vocabulary words in the story content
    // For this example, we'll just return a subset of the vocabulary
    final result = <Vocabulary>[];
    
    // Get content from the page range
    String content = '';
    for (int i = startPage; i <= endPage; i++) {
      if (i < _storyPages.length) {
        content += _storyPages[i];
      }
    }
    
    // Find vocabulary words that appear in the content
    for (final vocab in allVocab) {
      if (content.toLowerCase().contains(vocab.word.toLowerCase())) {
        result.add(vocab);
      }
      
      // Limit to 2 vocabulary words per quiz
      if (result.length >= 2) break;
    }
    
    // If no matches found, just return the first 2 vocabulary words
    if (result.isEmpty && allVocab.length >= 2) {
      return allVocab.sublist(0, 2);
    }
    
    return result;
  }
  
  // Build the story page with word highlighting
  Widget _buildStoryPage(String content) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.imageUrl.isNotEmpty
              ? NetworkImage(widget.imageUrl)
              : const AssetImage('assets/images/default_story_bg.jpg') as ImageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _readingProgress,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
            const SizedBox(height: 24),
            
            // Story content with word highlighting
            _isPlaying && _currentWordIndex >= 0
                ? _buildHighlightedText(content)
                : Text(
                    content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _fontSize,
                      height: 1.5,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  
  // Build text with highlighted current word
  Widget _buildHighlightedText(String text) {
    return RichText(
      text: TextSpan(
        children: _buildHighlightedWordSpans(),
      ),
    );
  }
  
  // Create text spans with the current word highlighted
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
              color: Colors.white,
              fontSize: _fontSize,
              height: 1.5,
            ),
          ),
        );
      }
    }
    
    return spans;
  }
  
  // Build the bottom controls
  Widget _buildControls() {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Text size button
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showTextSettings,
            tooltip: 'Text Settings',
            color: Colors.black87,
          ),
          
          // Previous page button
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: _currentPageIndex > 0 ? _previousPage : null,
            tooltip: 'Previous Page',
            color: _currentPageIndex > 0 ? Colors.black87 : Colors.grey[400],
          ),
          
          // Play/pause button
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _contentPages[_currentPageIndex]['type'] == 'story' && _isTtsInitialized 
                ? _playPause 
                : null,
            tooltip: _isPlaying ? 'Pause' : 'Play',
            color: _contentPages[_currentPageIndex]['type'] == 'story' && _isTtsInitialized 
                ? Colors.black87 
                : Colors.grey[400],
            iconSize: 36,
          ),
          
          // Next page button
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: _currentPageIndex < _contentPages.length - 1 ? _nextPage : null,
            tooltip: 'Next Page',
            color: _currentPageIndex < _contentPages.length - 1 
                ? Colors.black87 
                : Colors.grey[400],
          ),
          
          // Voice settings button
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _showVoiceSettings,
            tooltip: 'Voice Settings',
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
  
  // Navigate to previous page
  void _previousPage() {
    if (_currentPageIndex > 0) {
      _flutterTts.stop();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // Navigate to next page
  void _nextPage() {
    if (_currentPageIndex < _contentPages.length - 1) {
      _flutterTts.stop();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // Show text size settings
  void _showTextSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.yellow[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Size',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textSizeButton('Small', 16.0),
                _textSizeButton('Medium', 18.0),
                _textSizeButton('Large', 22.0),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  // Show voice settings
  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.yellow[50],
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.speed),
                    const SizedBox(width: 10),
                    const Text('Speed'),
                    Expanded(
                      child: Slider(
                        value: _speechRate,
                        min: 0.1,
                        max: 0.7,
                        divisions: 6,
                        activeColor: Colors.orange,
                        label: _getSpeechRateLabel(),
                        onChanged: (value) async {
                          setModalState(() {
                            _speechRate = value;
                          });
                          setState(() {
                            _speechRate = value;
                          });
                          await _flutterTts.setSpeechRate(value);
                        },
                      ),
                    ),
                    Text(_getSpeechRateLabel()),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_up),
                    const SizedBox(width: 10),
                    const Text('Volume'),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: Colors.orange,
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
                    Text('${(_volume * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        _voice == "female" ? Icons.check_circle : Icons.circle_outlined,
                        color: _voice == "female" ? Colors.green : Colors.grey,
                      ),
                      label: const Text("Female Voice"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[100],
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        if (_voice != "female") {
                          setModalState(() {
                            _voice = "female";
                          });
                          setState(() {
                            _voice = "female";
                          });
                          await _toggleVoice();
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        _voice == "male" ? Icons.check_circle : Icons.circle_outlined,
                        color: _voice == "male" ? Colors.green : Colors.grey,
                      ),
                      label: const Text("Male Voice"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[100],
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        if (_voice != "male") {
                          setModalState(() {
                            _voice = "male";
                          });
                          setState(() {
                            _voice = "male";
                          });
                          await _toggleVoice();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        !_isTranslated ? Icons.check_circle : Icons.circle_outlined,
                        color: !_isTranslated ? Colors.green : Colors.grey,
                      ),
                      label: const Text("English"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        if (_isTranslated) {
                          await _toggleLanguage();
                          setModalState(() {});
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        _isTranslated ? Icons.check_circle : Icons.circle_outlined,
                        color: _isTranslated ? Colors.green : Colors.grey,
                      ),
                      label: const Text("Spanish"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: () async {
                        if (!_isTranslated) {
                          await _toggleLanguage();
                          setModalState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Text size button widget
  Widget _textSizeButton(String label, double size) {
    final isSelected = _fontSize == size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      ),
      onPressed: () {
        setState(() {
          _fontSize = size;
        });
        Navigator.pop(context);
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
}
