import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/storytelling_bloc.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  @override
  void initState() {
    super.initState();
    context.read<StorytellingBloc>().add(LoadVocabulary());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
      ),
      body: BlocBuilder<StorytellingBloc, StorytellingState>(
        builder: (context, state) {
          if (state is VocabularyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VocabularyLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.vocabulary.length,
              itemBuilder: (context, index) {
                final vocab = state.vocabulary[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      vocab.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'From story: ${vocab.storyTitle}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synonym: ${vocab.synonym}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Related Words:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: vocab.relatedWords
                                  .map(
                                    (word) => Chip(
                                      label: Text(word),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is VocabularyError) {
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
                      context.read<StorytellingBloc>().add(LoadVocabulary());
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
