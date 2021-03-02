import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayerBackgroundPlaylist extends StatefulWidget {
  @override
  _AudioPlayerBackgroundPlaylistState createState() =>
      _AudioPlayerBackgroundPlaylistState();
}

class _AudioPlayerBackgroundPlaylistState
    extends State<AudioPlayerBackgroundPlaylist> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void setupPlaylist() async {
    audioPlayer.open(
        Playlist(audios: [
          /// For playing local assets, add Audio('assets/music.mp3')
          /// For playing local file, add Audio.file('path/to/file')

          Audio.network(
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
              metas: Metas(title: 'Song1', artist: 'Artist1')),
          Audio.network(
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
              metas: Metas(title: 'Song2', artist: 'Artist2')),
          Audio.network(
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
              metas: Metas(title: 'Song3', artist: 'Artist3')),
        ]),
        showNotification: true,
        autoStart: false);
  }

  playMusic() async {
    await audioPlayer.play();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
  }

  skipNext() async {
    await audioPlayer.next();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_previous_rounded),
                  onPressed: () => skipPrevious()),
              IconButton(
                  iconSize: 50,
                  icon: Icon(isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  onPressed: () => isPlaying ? pauseMusic() : playMusic()),
              IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_next_rounded),
                  onPressed: () => skipNext())
            ],
          );
        }),
      ),
    );
  }
}
