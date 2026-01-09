import 'package:flutter/material.dart';

class AudioPlayer extends StatefulWidget {
  final String audioUrl;

  const AudioPlayer({ super.key, required this.audioUrl});

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Audio Player'),
    );
  }
}