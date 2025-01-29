import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:medherence/features/auth/views/login_view.dart';
import 'package:medherence/features/monitor/view_model/reminder_view_model.dart';
import 'package:medherence/features/monitor/widget/medcoin_drop_widget.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  final VoidCallback onDelete;
  final VoidCallback onSend;
  final List<Drug> selectedDrugList;

  const VideoPreviewScreen({
    Key? key,
    required this.videoPath,
    required this.onDelete,
    required this.onSend,
    required this.selectedDrugList,
  }) : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _uploadProgress = 0.0; // Progress tracker

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

  // Upload Video to Firebase Storage with Progress
  void _uploadVideoToFirebase(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Uploading Video'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 10),
                Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
              ],
            ),
          );
        },
      );

      // Firebase Storage reference
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = basename(widget.videoPath);
      Reference storageRef =
          storage.ref().child('videos/patients/medication/use/$fileName');
      File videoFile = File(widget.videoPath);

      // Upload the video file with progress
      UploadTask uploadTask = storageRef.putFile(
        videoFile,
        SettableMetadata(contentType: 'video/mp4'),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the URL of the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Video uploaded! Download URL: $downloadUrl');

      // Handle medication activity with the URL
      _handleTakeMed(context, downloadUrl);

      // Close the progress dialog
      Navigator.of(context).pop();
    } catch (e) {
      print('Error uploading video: $e');
      setState(() {
        _isLoading = false;
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Upload Failed'),
            content: Text(
                'An error occurred while uploading the video. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Handle taking medication after video upload
  void _handleTakeMed(BuildContext context, String downloadUrl) async {
    setState(() {
      _isLoading = true;
    });

    // Calculate Medhecoin earned
    int medhecoinEarned = widget.selectedDrugList.length * 100;

    try {
      // Call setMedicationActivity and wait for completion
      String result = await context
          .read<ProfileViewModel>()
          .setMedicationActivityVideo(widget.selectedDrugList, downloadUrl);

      if (result == ok) {
        // Show MedCoin drop widget
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MedCoinDropWidget(
              medhecoinEarned: medhecoinEarned,
            );
          },
        );

        // Show success feedback
        showSnackBar(context, 'Medication Taken',
            backgroundColor: Colors.green);

        // Clear checked items
        Provider.of<ReminderState>(context, listen: false).clearCheckedItems();
      } else {
        showSnackBar(context, '$result', backgroundColor: Colors.red);
      }
    } catch (error) {
      // Handle error case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take medications: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    onPressed: _isLoading
                        ? null
                        : () => _uploadVideoToFirebase(
                            context), // Disable button when loading
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
