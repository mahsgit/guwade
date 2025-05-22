import 'dart:convert';
import 'package:buddy/features/storytelling/data/models/vocabulary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/story_model.dart';

abstract class StoryLocalDataSource {
  /// Gets the cached list of stories
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<StoryModel>> getStories();

  /// Gets the cached story details for a specific story
  ///
  /// Throws [CacheException] if no cached data is present.

  Future<void> cacheStories(List<StoryModel> stories);
  // Future<void> updateStoryProgress(String storyId, double progress);
  Future<void> cacheVocabulary(List<VocabularyModel> vocabulary);
  Future<List<VocabularyModel>> getVocabulary();
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
      // return Future.value(_getDummyStories());
      return Future.value([]);
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
  Future<void> cacheVocabulary(List<VocabularyModel> vocabulary) {
    return sharedPreferences.setString(
      'CACHED_VOCABULARY',
      json.encode(vocabulary.map((word) => word.toJson()).toList()),
    );
  }

  @override
  Future<List<VocabularyModel>> getVocabulary() {
    final jsonString = sharedPreferences.getString('CACHED_VOCABULARY');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => VocabularyModel.fromJson(json)).toList(),
      );
    } else {
      return Future.value([]); 
    }
  }
  

}