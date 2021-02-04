import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerUrl extends StatefulWidget {
  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<AudioPlayerUrl> {
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
  String url= 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

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
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });

    /// Optional
    audioPlayer.setUrl(url); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d.inMilliseconds;
      });
    });
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
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(url);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int milliseconds) {
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
                        ? audioPlayer.pause()
                        : playMusic();
                    //setState(() {});
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
                  Text(getTimeString(audioDuration))
                ],
              )
            ],
          )),
    );
  }
}
