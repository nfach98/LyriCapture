import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyricapture/presentation/navigation/app_router.dart';
import 'package:lyricapture/presentation/providers/song_search_provider.dart';
import 'package:provider/provider.dart';

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({super.key});

  @override
  State<SongSearchScreen> createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Songs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter song name or artist...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // final query = _searchController.text;
                    // if (query.isNotEmpty) {
                    //   context.read<SongSearchProvider>().search(query);
                    // }
                    context.pushNamed(AppRouter.lyrics);
                  },
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<SongSearchProvider>().search(query);
                }
              },
            ),
          ),
          Consumer<SongSearchProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (provider.error != null) {
                return Expanded(
                  child: Center(child: Text('Error: ${provider.error}')),
                );
              }
              if (provider.songs.isEmpty) {
                return const Expanded(
                  child: Center(child: Text('No songs found. Type to search.')),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: provider.songs.length,
                  itemBuilder: (context, index) {
                    final song = provider.songs[index];
                    return ListTile(
                      leading: song.albumArtUrl != null
                          ? Image.network(song.albumArtUrl!,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.music_note, size: 50),
                      title: Text(song.name),
                      subtitle: Text('${song.artistName} - ${song.albumName}'),
                      onTap: () {
                        // Navigate using go_router, passing the song object as 'extra'
                        context.push('/lyrics', extra: song);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
