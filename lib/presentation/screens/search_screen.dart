import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyricapture/presentation/navigation/app_router.dart';
import 'package:lyricapture/presentation/providers/search_provider.dart';
import 'package:lyricapture/presentation/widgets/search/song_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter song name or artist',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                      context.read<SearchProvider>().reset();
                    },
                    icon: const Icon(Icons.close),
                  )
                : null,
          ),
          style: theme.textTheme.bodyMedium,
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<SearchProvider>().search(query);
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<SearchProvider>(
          builder: (_, provider, __) {
            final songs = provider.songs;

            if (provider.isLoading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (provider.error != null) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Error: ${provider.error}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              );
            } else if (_searchController.text.isEmpty || songs.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No songs found. Type to search.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (_, index) {
                  final song = songs[index];

                  return SongCard(
                    song: songs[index],
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.pushNamed(
                        AppRouter.lyrics,
                        extra: song,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
