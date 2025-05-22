import 'package:buddy/features/stem/presentation/pages/stem_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StemDetailPage extends StatefulWidget {
  final StemCategory category;

  const StemDetailPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<StemDetailPage> createState() => _StemDetailPageState();
}

class _StemDetailPageState extends State<StemDetailPage> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  bool _isLoading = true;
  List<VideoItem> _videos = [];
  Map<String, bool> _watchedVideos = {};
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    // Load videos from playlist URL if available, otherwise use hardcoded fallback
    await _fetchPlaylistVideos();
    await _loadWatchedStatus();

    // Initialize the YouTube player with the first video
    if (_videos.isNotEmpty) {
      _initializeYoutubePlayer(_videos[0].id);
    } else {
      _videos = _getFallbackVideos(); // Fallback if playlist fetch fails
      if (_videos.isNotEmpty) {
        _initializeYoutubePlayer(_videos[0].id);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchPlaylistVideos() async {
    try {
      final playlistUrl = widget.category.playlistUrl;
      if (playlistUrl.isNotEmpty) {
        // Extract playlist ID from URL (e.g., PLWphMREEQDrgzJPYI_t-DNVb3FjVsMs-K)
        final playlistId = Uri.parse(playlistUrl).queryParameters['list'];
        if (playlistId != null) {
          // In a real app, use YouTube Data API to fetch playlist items
          // For this example, we'll simulate fetching with a delay and hardcoded IDs
          await Future.delayed(const Duration(seconds: 1));
          if (widget.category.id == 'math') {
            _videos = [
              VideoItem(
                id: 'a4FXl4zb3E4',
                title: 'Addition and Subtraction for Kids',
                description: 'Learn basic addition and subtraction with fun examples!',
                thumbnailUrl: 'https://img.youtube.com/vi/a4FXl4zb3E4/0.jpg',
                duration: '5:23',
              ),
              VideoItem(
                id: 'CH-_GwoO4xI',
                title: 'Counting Numbers for Children',
                description: 'Count from 1 to 20 with colorful animations.',
                thumbnailUrl: 'https://img.youtube.com/vi/CH-_GwoO4xI/0.jpg',
                duration: '4:15',
              ),
              VideoItem(
                id: 'bGetqbqDVaA',
                title: 'Shapes for Kids',
                description: 'Learn about different shapes in a fun way!',
                thumbnailUrl: 'https://img.youtube.com/vi/bGetqbqDVaA/0.jpg',
                duration: '6:30',
              ),
            ];
          } else if (widget.category.id == 'engineering') {
            _videos = [
              VideoItem(
                id: 'Ra7Bax6rGoQ',
                title: 'Simple Machines for Kids',
                description: 'Learn about levers, pulleys, and other simple machines.',
                thumbnailUrl: 'https://img.youtube.com/vi/Ra7Bax6rGoQ/0.jpg',
                duration: '7:12',
              ),
              VideoItem(
                id: 'EXfEySFqfyQ',
                title: 'Building Bridges',
                description: 'Discover how bridges are built and why they stay up!',
                thumbnailUrl: 'https://img.youtube.com/vi/EXfEySFqfyQ/0.jpg',
                duration: '5:45',
              ),
            ];
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching playlist: $e');
    }
  }

  List<VideoItem> _getFallbackVideos() {
    if (widget.category.id == 'math') {
      return [
        VideoItem(
          id: 'a4FXl4zb3E4',
          title: 'Addition and Subtraction for Kids',
          description: 'Learn basic addition and subtraction with fun examples!',
          thumbnailUrl: 'https://img.youtube.com/vi/a4FXl4zb3E4/0.jpg',
          duration: '5:23',
        ),
        VideoItem(
          id: 'CH-_GwoO4xI',
          title: 'Counting Numbers for Children',
          description: 'Count from 1 to 20 with colorful animations.',
          thumbnailUrl: 'https://img.youtube.com/vi/CH-_GwoO4xI/0.jpg',
          duration: '4:15',
        ),
        VideoItem(
          id: 'bGetqbqDVaA',
          title: 'Shapes for Kids',
          description: 'Learn about different shapes in a fun way!',
          thumbnailUrl: 'https://img.youtube.com/vi/bGetqbqDVaA/0.jpg',
          duration: '6:30',
        ),
      ];
    } else if (widget.category.id == 'engineering') {
      return [
        VideoItem(
          id: 'Ra7Bax6rGoQ',
          title: 'Simple Machines for Kids',
          description: 'Learn about levers, pulleys, and other simple machines.',
          thumbnailUrl: 'https://img.youtube.com/vi/Ra7Bax6rGoQ/0.jpg',
          duration: '7:12',
        ),
        VideoItem(
          id: 'EXfEySFqfyQ',
          title: 'Building Bridges',
          description: 'Discover how bridges are built and why they stay up!',
          thumbnailUrl: 'https://img.youtube.com/vi/EXfEySFqfyQ/0.jpg',
          duration: '5:45',
        ),
      ];
    }
    return [];
  }

  Future<void> _loadWatchedStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchedString = prefs.getString('${widget.category.id}_watched') ?? '{}';
      setState(() {
        _watchedVideos = Map<String, bool>.from(json.decode(watchedString));
      });
    } catch (e) {
      debugPrint('Error loading watched status: $e');
    }
  }

  Future<void> _saveWatchedStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${widget.category.id}_watched', json.encode(_watchedVideos));
      
      // Calculate and save actual progress
      final watchedCount = _watchedVideos.values.where((watched) => watched).length;
      final progress = _videos.isNotEmpty ? watchedCount / _videos.length : 0.0;
      await prefs.setDouble('${widget.category.id}_progress', progress);
    } catch (e) {
      debugPrint('Error saving watched status: $e');
    }
  }

  void _initializeYoutubePlayer(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        forceHD: false,
      ),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.playerState == PlayerState.ended) {
      setState(() {
        _watchedVideos[_videos[_currentVideoIndex].id] = true;
      });
      _saveWatchedStatus();

      if (_currentVideoIndex < _videos.length - 1) {
        Future.delayed(const Duration(seconds: 2), () {
          _playVideo(_currentVideoIndex + 1);
        });
      }
    }

    if (_controller.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
    }
  }

  void _playVideo(int index) {
    if (index >= 0 && index < _videos.length) {
      setState(() {
        _currentVideoIndex = index;
      });
      _controller.load(_videos[index].id);
      _controller.play();
    }
  }

  void _toggleWatched(int index) {
    final videoId = _videos[index].id;
    setState(() {
      _watchedVideos[videoId] = !(_watchedVideos[videoId] ?? false);
    });
    _saveWatchedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text(
                widget.category.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: widget.category.color,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _videos.isEmpty
              ? _buildEmptyState()
              : _buildContent(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(widget.category.color),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading videos...",
            style: TextStyle(
              color: widget.category.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No videos available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later for new content",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Go Back"),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.category.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // YouTube Player
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: widget.category.color,
          progressColors: ProgressBarColors(
            playedColor: widget.category.color,
            handleColor: widget.category.color,
          ),
          onReady: () {
            _controller.addListener(_onPlayerStateChange);
          },
        ),
        
        // Video Info
        if (!_isFullScreen && _videos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _videos[_currentVideoIndex].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _videos[_currentVideoIndex].description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _videos[_currentVideoIndex].duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    _buildWatchedToggle(_currentVideoIndex),
                  ],
                ),
              ],
            ),
          ),
        
        // Video List
        if (!_isFullScreen)
          Expanded(
            child: _buildVideoList(),
          ),
      ],
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        final isWatched = _watchedVideos[video.id] ?? false;
        final isActive = index == _currentVideoIndex;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isActive
                ? BorderSide(color: widget.category.color, width: 2)
                : BorderSide.none,
          ),
          elevation: isActive ? 4 : 1,
          child: InkWell(
            onTap: () => _playVideo(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Thumbnail with play indicator
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          video.thumbnailUrl,
                          width: 120,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 68,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isActive ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      if (isWatched)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Video info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: TextStyle(
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Watched toggle
                  _buildWatchedToggle(index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWatchedToggle(int index) {
    final videoId = _videos[index].id;
    final isWatched = _watchedVideos[videoId] ?? false;
    
    return GestureDetector(
      onTap: () => _toggleWatched(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isWatched ? Colors.green[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isWatched ? Colors.green : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isWatched ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: isWatched ? Colors.green : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              isWatched ? "Watched" : "Mark watched",
              style: TextStyle(
                fontSize: 12,
                color: isWatched ? Colors.green[700] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoItem {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String duration;

  VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
  });
}

class StemCategory {
  final String id;
  final String title;
  final Color color;
  final String playlistUrl;

  StemCategory({
    required this.id,
    required this.title,
    required this.color,
    required this.playlistUrl,
  });
}