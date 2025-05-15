import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/storytelling_bloc.dart';
import '../widgets/story_card.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<StorytellingBloc>().add(LoadStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.pushNamed(context, '/vocabulary');
            },
          ),
        ],
      ),
      body: BlocBuilder<StorytellingBloc, StorytellingState>(
        builder: (context, state) {
          if (state is StoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoriesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                final story = state.stories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StoryCard(
                    story: story,
                    onTap: () {
                      // TODO: Navigate to story detail page
                    },
                  ),
                );
              },
            );
          } else if (state is StoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StorytellingBloc>().add(LoadStories());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
