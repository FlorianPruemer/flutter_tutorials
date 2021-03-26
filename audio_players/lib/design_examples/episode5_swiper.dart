import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class Episode5Swiper extends StatefulWidget {
  @override
  _Episode5SwiperState createState() => _Episode5SwiperState();
}

class _Episode5SwiperState extends State<Episode5Swiper> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final SwiperController swiperController = SwiperController();
  double screenWidth = 0;
  double screenHeight = 0;
  Color highlightColor = Color(0xff35738a);
  List<Audio> audioList = [
    Audio('assets/allthat.mp3',
        metas: Metas(
            title: 'All That',
            artist: 'Benjamin Tissot',
            image: MetasImage.asset('assets/allthat_colored.jpg'))),
    Audio('assets/love.mp3',
        metas: Metas(
            title: 'Love',
            artist: 'Benjamin Tissot',
            image: MetasImage.asset('assets/love_colored.jpg'))),
    Audio('assets/thejazzpiano.mp3',
        metas: Metas(
            title: 'The Jazz Piano',
            artist: 'Benjamin Tissot',
            image: MetasImage.asset('assets/thejazzpiano_colored.jpg'))),
  ];

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    audioPlayer.open(Playlist(audios: audioList),
        autoStart: false, loopMode: LoopMode.playlist);
  }

  Widget swiper(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.45,
      child: Swiper(
        controller: swiperController,
        itemCount: audioList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset(
              audioList[index].metas.image.path,
              fit: BoxFit.cover,
            ),
          );
        },
        onIndexChanged: (newIndex) async {
          audioPlayer.playlistPlayAtIndex(newIndex);
          },
        viewportFraction: 0.75,
        scale: 0.8,
      ),
    );
  }

  Widget titleBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Text(
      realtimePlayingInfos.current.audio.audio.metas.title,
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget artistText(RealtimePlayingInfos realtimePlayingInfos) {
    return Text(
      realtimePlayingInfos.current.audio.audio.metas.artist,
      style: TextStyle(color: Colors.grey[600], fontSize: 15),
    );
  }

  Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
    return SliderTheme(
        data: SliderThemeData(
            thumbColor: highlightColor,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1),
            activeTrackColor: highlightColor,
            inactiveTrackColor: Colors.grey[800],
            overlayColor: Colors.transparent),
        child: Slider.adaptive(
            value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
            max: realtimePlayingInfos.duration.inSeconds.toDouble(),
            min: 0,
            onChanged: (value) {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            }));
  }

  Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            transformString(realtimePlayingInfos.currentPosition.inSeconds),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous_rounded),
                onPressed: () => swiperController.previous(),
                iconSize: screenHeight * 0.06,
                color: Colors.white,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              Container(
                decoration: BoxDecoration(
                    color: highlightColor, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(realtimePlayingInfos.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  onPressed: () => audioPlayer.playOrPause(),
                  iconSize: screenHeight * 0.06,
                  color: Colors.white,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.skip_next_rounded),
                onPressed: () => swiperController.next(),
                iconSize: screenHeight * 0.06,
                color: Colors.white,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),
          Text(
            transformString(realtimePlayingInfos.duration.inSeconds),
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ],
      ),
    );
  }

  /// Transforms string into a mm:ss format
  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff16161e),
      body: audioPlayer.builderRealtimePlayingInfos(
          builder: (context, realtimePlayingInfos) {
        if (realtimePlayingInfos != null) {
          return Column(
            children: [
              SizedBox(height: screenHeight * 0.15),
              swiper(realtimePlayingInfos),
              SizedBox(height: screenHeight * 0.05),
              titleBar(realtimePlayingInfos),
              SizedBox(height: screenHeight * 0.01),
              artistText(realtimePlayingInfos),
              SizedBox(height: screenHeight * 0.03),
              slider(realtimePlayingInfos),
              SizedBox(height: screenHeight * 0.03),
              playBar(realtimePlayingInfos)
            ],
          );
        } else {
          return Column();
        }
      }),
    );
  }
}
