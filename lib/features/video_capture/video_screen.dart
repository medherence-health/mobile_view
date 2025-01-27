import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  int _countdown = 30; // Countdown starting at 30 seconds
  late Timer _timer; // Timer for countdown

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check and request camera permission
    if (await Permission.camera.isGranted) {
      _hasPermission = true;
      _initializeCamera();
    } else {
      _hasPermission = false;
      setState(() {});
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _hasPermission = true;
      _initializeCamera();
    } else if (status.isDenied) {
      final newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        _hasPermission = true;
        _initializeCamera();
      } else {
        _hasPermission = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showPermissionDeniedDialog();
          }
        });
      }
    } else if (status.isPermanentlyDenied) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showPermissionDeniedDialog();
        }
      });
    }
    setState(() {});
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text(
            "Camera permission is required to use this feature. Please enable it in the app settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
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

        final directory = await getTemporaryDirectory();
        final videoPath = path.join(directory.path, '${DateTime.now()}.mp4');

        await _cameraController!.startVideoRecording();
        _startCountdown();

        await Future.delayed(const Duration(seconds: 30));
        final file = await _cameraController!.stopVideoRecording();

        setState(() {
          _isRecording = false;
        });

        file.saveTo(videoPath);
        print("Video saved to $videoPath");

        // Reset countdown after recording
        setState(() {
          _countdown = 30;
        });
      } catch (e) {
        print("Error during video recording: $e");
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
        setState(() {
          _isRecording = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capture Video")),
      body: _hasPermission
          ? _isCameraInitialized
              ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isRecording ? null : _startVideoRecording,
                      child: Text(_isRecording
                          ? "Recording... ($_countdown)"
                          : "Start Recording"),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
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
                    onPressed: _requestPermission,
                    child: const Text("Enable Camera Permission"),
                  ),
                ],
              ),
            ),
    );
  }
}
