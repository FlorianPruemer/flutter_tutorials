import 'package:audio_players/audio_player_local_asset.dart';
import 'package:audio_players/audio_player_url.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      /// Swap classes here:
      ///       - "AudioPlayerUrl()" plays audio file from a url source (can be local or on the Internet)
      ///       - "AudioPlayerLocalAsset()" plays audio file from local asset (stored in /assets)
      home: AudioPlayerUrl(),
    );
  }
}
