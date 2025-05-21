import 'package:buddy/features/storytelling/domain/entities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  final List<Vocabulary> vocabulary;
  final VoidCallback onComplete;

  const QuizPage({
    Key? key,
    required this.vocabulary,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late FlutterTts _flutterTts;
  bool _isTtsPlaying = false;
  int? _selectedOption;
  bool? _isCorrect;
  late Vocabulary _currentVocab;
  late List<String> _options;
  late int _correctIndex;
  
  @override
  void initState() {
    super.initState();
    _initTts();
    _setupQuiz();
  }
  
  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
  
  // Initialize TTS
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setVolume(0.8);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setPitch(1.0);
  }
  
  // Setup quiz with random vocabulary
  void _setupQuiz() {
    final random = Random();
    
    // Select a random vocabulary word
    _currentVocab = widget.vocabulary[random.nextInt(widget.vocabulary.length)];
    
    // Create options (1 correct, 3 incorrect)
    _options = [_currentVocab.synonym];
    
    // Add incorrect options (other synonyms or made-up options)
    final otherVocab = widget.vocabulary
        .where((v) => v?.word != _currentVocab.word)
        .toList();
    
    if (otherVocab.isNotEmpty) {
      for (int i = 0; i < min(3, otherVocab.length); i++) {
        _options.add(otherVocab[i].synonym);
      }
    }
    
    // Fill remaining options if needed
    while (_options.length < 4) {
      _options.add("Option ${_options.length + 1}");
    }
    
    // Shuffle options and find correct index
    _options.shuffle();
    _correctIndex = _options.indexOf(_currentVocab.synonym);
  }
  
  // Handle option selection
  void _selectOption(int index) {
    setState(() {
      _selectedOption = index;
      _isCorrect = index == _correctIndex;
    });
    
    // Speak feedback
    _speakFeedback(_isCorrect!);
    
    // Move to next page after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }
  
  // Speak the question and options
  Future<void> _speakQuiz() async {
    setState(() {
      _isTtsPlaying = true;
    });
    
    await _flutterTts.speak("What does ${_currentVocab.word} mean?");
    await Future.delayed(const Duration(milliseconds: 1500));
    
    for (int i = 0; i < _options.length; i++) {
      await _flutterTts.speak("Option ${i + 1}: ${_options[i]}");
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    
    setState(() {
      _isTtsPlaying = false;
    });
  }
  
  // Speak feedback based on answer
  Future<void> _speakFeedback(bool isCorrect) async {
    if (isCorrect) {
      await _flutterTts.speak("Great job! That's correct!");
    } else {
      await _flutterTts.speak("Not quite. The correct answer is ${_currentVocab.synonym}");
    }
  }
  
  // Stop TTS
  Future<void> _stopTts() async {
    await _flutterTts.stop();
    setState(() {
      _isTtsPlaying = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[300]!,
            Colors.blue[600]!,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  width: 20,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index < 3 ? Colors.white : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Question
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "What does \"${_currentVocab.word}\" mean?",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose the correct meaning",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Options
            ...List.generate(_options.length, (index) {
              final bool isSelected = _selectedOption == index;
              final bool isCorrect = index == _correctIndex;
              
              // Determine button color
              Color buttonColor;
              if (_isCorrect != null) {
                if (isCorrect) {
                  buttonColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  buttonColor = Colors.red;
                } else {
                  buttonColor = Colors.white;
                }
              } else {
                buttonColor = Colors.white;
              }
              
              return GestureDetector(
                onTap: _isCorrect == null ? () => _selectOption(index) : null,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: Colors.yellow, width: 3)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.yellow : Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.blue[800],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _options[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.black87,
                          ),
                        ),
                      ),
                      if (_isCorrect != null && isCorrect)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      if (_isCorrect != null && isSelected && !isCorrect)
                        const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 20),
            
            // Feedback
            if (_isCorrect != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect! ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _isCorrect! ? "Great job!" : "Try again!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect! ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isCorrect! 
                          ? "\"${_currentVocab.word}\" means \"${_currentVocab.synonym}\""
                          : "\"${_currentVocab.word}\" actually means \"${_currentVocab.synonym}\"",
                      style: TextStyle(
                        fontSize: 16,
                        color: _isCorrect! ? Colors.green[800] : Colors.red[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            
            const Spacer(),
            
            // Audio button
            if (_isCorrect == null)
              ElevatedButton.icon(
                onPressed: _isTtsPlaying ? _stopTts : _speakQuiz,
                icon: Icon(_isTtsPlaying ? Icons.stop : Icons.volume_up),
                label: Text(_isTtsPlaying ? "Stop" : "Read Aloud"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            
            // Next button
            if (_isCorrect != null)
              ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
