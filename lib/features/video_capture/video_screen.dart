import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VideoCaptureScreen extends StatefulWidget {
  const VideoCaptureScreen({Key? key}) : super(key: key);

  @override
  _VideoCaptureScreenState createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      // Initialize the first camera
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_isRecording) {
      try {
        setState(() {
          _isRecording = true;
        });

        // Get a temporary directory to store the video
        final directory = await getTemporaryDirectory();
        final videoPath = path.join(directory.path, '${DateTime.now()}.mp4');

        // Start recording
        await _cameraController!.startVideoRecording();

        // Stop recording after 30 seconds
        await Future.delayed(const Duration(seconds: 30));
        final file = await _cameraController!.stopVideoRecording();

        setState(() {
          _isRecording = false;
        });

        // Move the video to the intended location (optional)
        file.saveTo(videoPath);

        // Notify the user or handle the video file
        print("Video saved to $videoPath");
      } catch (e) {
        print("Error during video recording: $e");
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capture Video")),
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isRecording ? null : _startVideoRecording,
                  child:
                      Text(_isRecording ? "Recording..." : "Start Recording"),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
