import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerLocalAsset extends StatefulWidget {
  @override
  _AudioPlayerLocalAssetState createState() => _AudioPlayerLocalAssetState();
}

class _AudioPlayerLocalAssetState extends State<AudioPlayerLocalAsset> {
  /// For clarity, I added the terms compulsory and optional to certain sections
  /// to maintain clarity as to what is really needed for a functioning audio player
  /// and what is added for further interaction.
  ///
  /// 'Compulsory': A functioning audio player with:
  ///             - Play/Pause button
  ///
  /// 'Optional': A functioning audio player with:
  ///             - Play/Pause button
  ///             - time stamps for progress and duration
  ///             - slider to jump within the audio file
  ///

  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;
  String filePath = 'music.mp3';

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          value: (timeProgress / 1000).floorToDouble(),
          max: (audioDuration / 1000).floorToDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    /// Compulsory
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });

    /// Optional
    audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      setState(() {
        timeProgress = p.inMilliseconds;
      });
    });
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    await audioCache.play(filePath);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }



  /// Optional
  Future<int> _getAudioDuration() async {
    File audioFile = await audioCache.load(filePath);
    await audioPlayer.setUrl(
      audioFile.path,
    );

    audioDuration = await Future.delayed(
      Duration(seconds: 2),
      () => audioPlayer.getDuration(),
    );

    return audioDuration;
  }

  /// Optional
  Widget getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getAudioDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Waiting...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(getTimeString(snapshot.data));
        }
        return null; // unreachable
      },
    );
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  /// Optional
  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Compulsory
              IconButton(
                  iconSize: 50,
                  onPressed: () {
                    audioPlayerState == AudioPlayerState.PLAYING
                        ? pauseMusic()
                        : playMusic();
                    setState(() {});
                  },
                  icon: Icon(audioPlayerState == AudioPlayerState.PLAYING
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded)),

              /// Optional
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTimeString(timeProgress)),
                  SizedBox(width: 20),
                  Container(width: 200, child: slider()),
                  SizedBox(width: 20),
                  audioDuration == 0
                      ? getLocalFileDuration()
                      : Text(getTimeString(audioDuration))
                ],
              )
            ],
          )),
    );
  }
}
