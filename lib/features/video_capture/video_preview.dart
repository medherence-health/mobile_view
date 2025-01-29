import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  final VoidCallback onDelete;
  final VoidCallback onSend;

  const VideoPreviewScreen({
    Key? key,
    required this.videoPath,
    required this.onDelete,
    required this.onSend,
  }) : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Player
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Delete Button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 30),
              onPressed: widget.onDelete,
            ),
          ),

          // Controls (Play/Pause Button + Seekbar + Send Button)
          Positioned(
            bottom: 20,
            left: 0,
            right: 10,
            child: Row(
              children: [
                // Play/Pause Button
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.black,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),

                // Seek Bar
                Expanded(
                  child: VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white54,
                    ),
                  ),
                ),

                // Send Button inside a Rounded Rectangle
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 25),
                    onPressed: widget.onSend,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
