import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Episode4YellowGradient extends StatefulWidget {
  @override
  _Episode4YellowGradientState createState() => _Episode4YellowGradientState();
}

class _Episode4YellowGradientState extends State<Episode4YellowGradient> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double screenWidth = 0;
  double screenHeight = 0;

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

  /// Transforms string into a mm:ss format
  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  Widget audioImage(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      height: screenWidth * 0.8,
      width: screenWidth * 0.8,
      child: Material(
        elevation: 18.0,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.asset(
            realtimePlayingInfos.current.audio.audio.metas.image.path,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget titleBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          realtimePlayingInfos.current.audio.audio.metas.title,
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.favorite,
          color: Color(0xffe3eb6b),
        ),
      ],
    );
  }

  Widget artistText(RealtimePlayingInfos realtimePlayingInfos) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          realtimePlayingInfos.current.audio.audio.metas.artist,
          style: TextStyle(color: Colors.grey[600]),
        ));
  }

  Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
    return SliderTheme(
      data: SliderThemeData(
          trackShape: CustomTrackShape(),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
      child: Slider.adaptive(
          value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
          max: realtimePlayingInfos.duration.inSeconds.toDouble(),
          activeColor: Color(0xffe3eb6b),
          inactiveColor: Colors.grey[850],
          onChanged: (value) {
            audioPlayer.seek(Duration(seconds: value.toInt()));
          }),
    );
  }

  Widget timestamps(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          transformString(realtimePlayingInfos.currentPosition.inSeconds),
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          transformString(realtimePlayingInfos.duration.inSeconds),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.compare_arrows_rounded),
          onPressed: () {},
          iconSize: screenHeight * 0.03,
          color: Colors.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.fast_rewind_rounded),
          onPressed: () => audioPlayer.previous(),
          iconSize: screenHeight * 0.03,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(realtimePlayingInfos.isPlaying
              ? Icons.pause_circle_filled_rounded
              : Icons.play_circle_fill_rounded),
          onPressed: () => audioPlayer.playOrPause(),
          iconSize: screenHeight * 0.1,
          color: Color(0xffe3eb6b),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.fast_forward_rounded),
          onPressed: () => audioPlayer.next(),
          iconSize: screenHeight * 0.03,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.autorenew_rounded),
          onPressed: () {},
          iconSize: screenHeight * 0.03,
          color: Colors.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: audioPlayer.builderRealtimePlayingInfos(
          builder: (context, realtimePlayingInfos) {
        if (realtimePlayingInfos != null) {
          return Stack(children: [
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffcbfd96), Color(0xffe3eb6b)])),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.1, right: screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  audioImage(realtimePlayingInfos),
                  SizedBox(height: screenHeight * 0.05),
                  titleBar(realtimePlayingInfos),
                  SizedBox(height: screenHeight * 0.01),
                  artistText(realtimePlayingInfos),
                  SizedBox(height: screenHeight * 0.05),
                  slider(realtimePlayingInfos),
                  timestamps(realtimePlayingInfos),
                  SizedBox(height: screenHeight * 0.05),
                  playBar(realtimePlayingInfos),
                  SizedBox(height: screenHeight * 0.1)
                ],
              ),
            ),
          ]);
        } else {
          return Column();
        }
      }),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  /// Removes side padding of slider
  /// Credit goes to @clocksmith, https://github.com/flutter/flutter/issues/37057
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
