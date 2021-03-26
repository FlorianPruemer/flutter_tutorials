import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Episode6PlaylistView extends StatefulWidget {
  @override
  _Episode6PlaylistViewState createState() =>
      _Episode6PlaylistViewState();
}

class _Episode6PlaylistViewState extends State<Episode6PlaylistView> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double screenHeight = 0;
  double screenWidth = 0;
  final Color mainColor = Color(0xff181c27);
  final Color inactiveColor = Color(0xff5d6169);
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
    Audio('assets/allthat.mp3',
        metas: Metas(
            title: 'All That 2',
            artist: 'Benjamin Tissot',
            image: MetasImage.asset('assets/allthat_colored.jpg'))),
    Audio('assets/love.mp3',
        metas: Metas(
            title: 'Love 2',
            artist: 'Benjamin Tissot',
            image: MetasImage.asset('assets/love_colored.jpg'))),
    Audio('assets/thejazzpiano.mp3',
        metas: Metas(
            title: 'The Jazz Piano 2',
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

  Widget playlistImage() {
    return Container(
      height: screenHeight * 0.25,
      width: screenHeight * 0.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset(
          'assets/background_circular.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget playlistTitle() {
    return Text(
      'Chill Playlist',
      style: TextStyle(
          fontFamily: 'Barlow',
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold),
    );
  }

  Widget playButton() {
    return Container(
      width: screenWidth * 0.25,
      child: TextButton(
          onPressed: () => audioPlayer.playlistPlayAtIndex(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                color: mainColor,
              ),
              SizedBox(width: 5),
              Text(
                'Play',
                style: TextStyle(color: mainColor),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )))),
    );
  }

  Widget playlist(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      height: screenHeight * 0.35,
      alignment: Alignment.bottomLeft,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: audioList.length,
          itemBuilder: (context, index) {
            return playlistItem(index);
          }),
    );
  }

  Widget playlistItem(int index) {
    return InkWell(
      onTap: () => audioPlayer.playlistPlayAtIndex(index),
      splashColor: Colors.transparent,
      highlightColor: mainColor,
      child: Container(
        height: screenHeight * 0.07,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Text(
                '0${index + 1}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Barlow'),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audioList[index].metas.title,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow'),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      audioList[index].metas.artist,
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff5d6169),
                          fontFamily: 'Barlow'),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.menu_rounded,
                color: inactiveColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomPlayContainer(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.08,
              width: screenHeight * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  realtimePlayingInfos.current.audio.audio.metas.image.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    realtimePlayingInfos.current.audio.audio.metas.title,
                    style: TextStyle(
                        fontSize: 15,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow'),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    realtimePlayingInfos.current.audio.audio.metas.artist,
                    style: TextStyle(
                        fontSize: 13, color: mainColor, fontFamily: 'Barlow'),
                  )
                ],
              ),
            ),
            Icon(
              Icons.favorite_outline_rounded,
              color: mainColor,
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            IconButton(
                icon: Icon(realtimePlayingInfos.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded),
                iconSize: screenHeight * 0.07,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: mainColor,
                onPressed: () => audioPlayer.playOrPause())
          ],
        ),
      ),
    );
  }

  /// List of placeholder icon buttons used for the bottom navigation bar
  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: mainColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: inactiveColor,
      iconSize: screenWidth*0.07,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded), label: 'Library'),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_rounded), label: 'Hotlist')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: mainColor,
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: bottomNavigationBar(),
          ),
        ),
        body: audioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlayingInfos) {
          if (realtimePlayingInfos != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                playlistImage(),
                SizedBox(height: screenHeight * 0.02),
                playlistTitle(),
                SizedBox(height: screenHeight * 0.02),
                playButton(),
                SizedBox(height: screenHeight * 0.02),
                playlist(realtimePlayingInfos),
                bottomPlayContainer(realtimePlayingInfos)
              ],
            );
          } else {
            return Column();
          }
        }));
  }
}
