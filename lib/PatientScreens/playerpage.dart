import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'EmojiFeedback.dart';
import 'TrackActivity.dart';

class PlayerPage extends StatefulWidget {
  final String videoUrl;
  final String email;
  final String Foldername;
  final String day;
  final String activity;

  const PlayerPage({
    Key? key,
    required this.videoUrl,
    required this.email, required this.Foldername, required this.day, required this.activity,
  }) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showDoneButton = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      '${widget.videoUrl}',
    );

    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    _videoPlayerController.setLooping(true);

    // Uncomment the line below if you want the video to start playing automatically
    // _videoPlayerController.play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void startPlaying() {
    setState(() {
      _isPlaying = true;
      _videoPlayerController.play();
      _startTimer();
    });
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    Timer(duration, () {
      setState(() {
        _showDoneButton = true;
      });
    });
  }

  void doneButtonPressed() {
    // Navigate to TrackActivity page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmojiFeedback(
          email: widget.email, fn: '${widget.Foldername}',
          day: '${widget.day}',
          activity: '${widget.activity}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
            SizedBox(height: 16),
            if (!_isPlaying)
              Container(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white
                  ),
                  onPressed: startPlaying,
                  child: Text('Start'),
                ),
              ),
            if (_showDoneButton)
              Container(
                width: 250,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white
                  ),
                  onPressed: doneButtonPressed,
                  child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



