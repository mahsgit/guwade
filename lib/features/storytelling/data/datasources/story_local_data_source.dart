import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';
import '../models/story_detail_model.dart';

abstract class StoryLocalDataSource {
  /// Gets the cached list of stories
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<StoryModel>> getStories();

  /// Gets the cached story details for a specific story
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<StoryDetailModel> getStoryDetails(String storyId);

  Future<void> cacheStories(List<StoryModel> stories);
  Future<void> cacheStoryDetails(StoryDetailModel storyDetail);
  Future<void> updateStoryProgress(String storyId, double progress);
}

class StoryLocalDataSourceImpl implements StoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  StoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<StoryModel>> getStories() {
    final jsonString = sharedPreferences.getString('CACHED_STORIES');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => StoryModel.fromJson(json)).toList(),
      );
    } else {
      // For demo purposes, return dummy data
      return Future.value(_getDummyStories());
    }
  }

  @override
  Future<StoryDetailModel> getStoryDetails(String storyId) {
    final jsonString =
        sharedPreferences.getString('CACHED_STORY_DETAIL_$storyId');
    if (jsonString != null) {
      return Future.value(
        StoryDetailModel.fromJson(json.decode(jsonString)),
      );
    } else {
      // For demo purposes, return dummy data
      return Future.value(_getDummyStoryDetail(storyId));
    }
  }

  @override
  Future<void> cacheStories(List<StoryModel> stories) {
    return sharedPreferences.setString(
      'CACHED_STORIES',
      json.encode(stories.map((story) => story.toJson()).toList()),
    );
  }

  @override
  Future<void> cacheStoryDetails(StoryDetailModel storyDetail) {
    return sharedPreferences.setString(
      'CACHED_STORY_DETAIL_${storyDetail.story.title}',
      json.encode(storyDetail.toJson()),
    );
  }

  @override
  Future<void> updateStoryProgress(String storyId, double progress) {
    return sharedPreferences.setDouble('STORY_PROGRESS_$storyId', progress);
  }

  // Dummy data for development
  List<StoryModel> _getDummyStories() {
    return [
      StoryModel(
        id: '1',
        title: 'Fairy Tale Story',
        storyBody:
            'Once upon a time, there was a kind and gentle girl named Cinderella...',
        imageUrl: 'https://via.placeholder.com/300',
      ),
      StoryModel(
        id: '2',
        title: 'The Brave Little Robot',
        storyBody:
            'A brave little robot named Beep lived in a futuristic city...',
        imageUrl: 'https://via.placeholder.com/300',
      ),
      StoryModel(
        id: '3',
        title: 'The Counting Adventure',
        storyBody: 'Once upon a time, there was a curious boy named Max...',
        imageUrl: 'https://via.placeholder.com/300',
      ),
    ];
  }

  StoryDetailModel _getDummyStoryDetail(String storyId) {
    // Find the story from dummy stories
    final story = _getDummyStories().firstWhere(
      (s) => s.title == storyId,
      orElse: () => _getDummyStories().first,
    );

    return StoryDetailModel.dummy(story);
  }
}
