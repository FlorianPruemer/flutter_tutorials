import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Episode1CircularProgress extends StatefulWidget {
  @override
  _Episode1CircularProgressState createState() =>
      _Episode1CircularProgressState();
}

class _Episode1CircularProgressState
    extends State<Episode1CircularProgress> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    await audioPlayer.open(Audio('assets/music.mp3'),
        autoStart: false,
        playInBackground: PlayInBackground.disabledRestoreOnForeground);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Widget circularAudioPlayer(
      RealtimePlayingInfos realtimePlayingInfos, double screenWidth) {
    Color primaryColor = Color(0xff2f6f88);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        CircularPercentIndicator(
          arcType: ArcType.HALF,
          backgroundColor: primaryColor,
          progressColor: Colors.white,
          radius: screenWidth / 2,
          center: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            color: primaryColor,
            iconSize: screenWidth / 8,
            icon: Icon(realtimePlayingInfos.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded),
            onPressed: () => audioPlayer.playOrPause(),
          ),
          percent: realtimePlayingInfos.currentPosition.inSeconds /
              realtimePlayingInfos.duration.inSeconds,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_circular.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: audioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlayingInfos) {
          if (realtimePlayingInfos != null) {
            return circularAudioPlayer(realtimePlayingInfos, screenWidth);
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
