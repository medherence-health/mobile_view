import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

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
  bool _hasPermission = false;
  int _countdown = 30;
  late Timer _timer;
  late VideoPlayerController _videoPlayerController;
  String _videoPath = '';
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.camera.isGranted) {
      _hasPermission = true;
      _initializeCamera();
    } else {
      _hasPermission = false;
      setState(() {});
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _startVideoRecording() async {
    _countdown = 30;
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_isRecording) {
      try {
        setState(() {
          _isRecording = true;
        });

        final directory = await getTemporaryDirectory();
        _videoPath = path.join(directory.path, '${DateTime.now()}.mp4');

        await _cameraController!.startVideoRecording();
        _startCountdown();

        await Future.delayed(const Duration(seconds: 30));
        final file = await _cameraController!.stopVideoRecording();

        setState(() {
          _isRecording = false;
        });

        file.saveTo(_videoPath);
        _initializeVideoPreview();
      } catch (e) {
        debugPrint("Error during video recording: $e");
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_countdown == 0) {
        _stopRecording();
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _initializeVideoPreview() {
    _videoPlayerController = VideoPlayerController.file(File(_videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  void _stopRecording() async {
    if (_cameraController != null &&
        _cameraController!.value.isRecordingVideo) {
      final file = await _cameraController!.stopVideoRecording();

      setState(() {
        _isRecording = false;
      });

      file.saveTo(_videoPath);
      _initializeVideoPreview();
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer.cancel();
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capture Video")),
      body: _hasPermission
          ? _isCameraInitialized
              ? Stack(
                  children: [
                    // Camera preview
                    Center(
                      child: Transform.scale(
                        scale: 1 /
                            (_cameraController!.value.aspectRatio /
                                MediaQuery.of(context).size.aspectRatio),
                        child: AspectRatio(
                          aspectRatio: _cameraController!.value.aspectRatio,
                          child: Transform.rotate(
                            angle: 90 * (3.141592653589793 / 180),
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                      ),
                    ),
                    if (_isRecording)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Recording... ($_countdown)",
                                style: const TextStyle(color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: _stopRecording,
                                child: const Text("Stop Recording"),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: _startVideoRecording,
                            child: const Text("Start Recording"),
                          ),
                        ),
                      ),
                  ],
                )
              : const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Camera permission is required to use this feature.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkPermissions,
                    child: const Text("Enable Camera Permission"),
                  ),
                ],
              ),
            ),
    );
  }
}
