import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Episode2LinearProgress extends StatefulWidget {
  @override
  _Episode2LinearProgressState createState() =>
      _Episode2LinearProgressState();
}

class _Episode2LinearProgressState extends State<Episode2LinearProgress> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    audioPlayer.open(
        Playlist(audios: [
          Audio('assets/allthat.mp3',
              metas: Metas(
                  title: 'All That',
                  artist: 'Benjamin Tissot',
                  image: MetasImage.asset('assets/allthat.jpg'))),
          Audio('assets/love.mp3',
              metas: Metas(
                  title: 'Love',
                  artist: 'Benjamin Tissot',
                  image: MetasImage.asset('assets/love.jpg'))),
          Audio('assets/thejazzpiano.mp3',
              metas: Metas(
                  title: 'The Jazz Piano',
                  artist: 'Benjamin Tissot',
                  image: MetasImage.asset('assets/thejazzpiano.jpg'))),
        ]),
        autoStart: false,
        loopMode: LoopMode.playlist);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Widget linearProgressBar(Duration currentPosition, Duration duration) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: LinearPercentIndicator(
        width: 250,
        backgroundColor: Colors.grey,
        percent: currentPosition.inSeconds / duration.inSeconds,
        progressColor: Colors.white,
      ),
    );
  }

  Widget audioPlayerUI(RealtimePlayingInfos realtimePlayingInfos) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          realtimePlayingInfos.current.audio.audio.metas.title,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        SizedBox(height: 10),
        Text(realtimePlayingInfos.current.audio.audio.metas.artist,
            style: TextStyle(color: Colors.white, fontSize: 15)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTimeText(realtimePlayingInfos.currentPosition),
            linearProgressBar(realtimePlayingInfos.currentPosition,
                realtimePlayingInfos.duration),
            getTimeText(realtimePlayingInfos.duration)
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.skip_previous_rounded),
                onPressed: () =>
                    audioPlayer.previous()
                ,
                iconSize: 60,
                color: Colors.white),
            IconButton(
                icon: Icon(realtimePlayingInfos.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded),
                onPressed: () =>
                    audioPlayer.playOrPause()
                ,
                iconSize: 60,
                color: Colors.white),
            IconButton(
                icon: Icon(Icons.skip_next_rounded),
                onPressed: () =>
                    audioPlayer.next()
                ,
                iconSize: 60,
                color: Colors.white),
          ],
        )
      ],
    );
  }

  Widget getTimeText(Duration seconds) {
    return Text(
      transformString(seconds.inSeconds),
      style: TextStyle(color: Colors.white),
    );
  }

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: audioPlayer.builderRealtimePlayingInfos(
                builder: (context, realtimePlayingInfos) {
                  if (realtimePlayingInfos != null) {
                    return audioPlayerUI(realtimePlayingInfos);
                  } else {
                    return Column();
                  }
                }),
          )),
    );
  }
}
