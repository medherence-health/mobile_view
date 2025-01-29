import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:medherence/features/video_capture/video_preview.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCaptureScreen extends StatefulWidget {
  final List<Drug> drugList;

  const VideoCaptureScreen({Key? key, required this.drugList})
      : super(key: key);

  @override
  _VideoCaptureScreenState createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  List<Drug> drugList = [];
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  int _countdown = 30;
  Timer? _timer;
  String _videoPath = '';

  @override
  void initState() {
    drugList = widget.drugList;
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
        _stopRecording();
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

  void _stopRecording() async {
    if (_cameraController != null &&
        _cameraController!.value.isRecordingVideo) {
      final file = await _cameraController!.stopVideoRecording();
      _timer?.cancel();

      setState(() {
        _isRecording = false;
      });

      file.saveTo(_videoPath);

      // Navigate to the video preview screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewScreen(
              videoPath: _videoPath,
              onDelete: _deleteVideo,
              onSend: _sendVideo,
              selectedDrugList: drugList,
            ),
          ),
        );
      }
    }
  }

  void _deleteVideo() {
    setState(() {
      _videoPath = '';
    });
    Navigator.pop(context);
  }

  void _sendVideo() {
    debugPrint("Sending video: $_videoPath");
    // Implement upload functionality here
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
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
                    // Camera Preview
                    Center(
                      child: Transform.scale(
                        scale: 1.5,
                        child: AspectRatio(
                          aspectRatio: _cameraController!.value.aspectRatio,
                          child: Transform.rotate(
                            angle: 90 * (3.141592653589793 / 180),
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                      ),
                    ),

                    // Countdown Timer & Controls
                    if (_isRecording)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _countdown <= 10
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                child: Text(
                                  "($_countdown)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
          : const Center(child: Text("Camera permission required.")),
    );
  }
}
