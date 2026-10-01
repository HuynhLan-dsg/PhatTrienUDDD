import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class WebCameraScreen extends StatefulWidget {
  final bool video; // true: quay video, false: chụp ảnh
  const WebCameraScreen({super.key, this.video = true});
  @override
  State<WebCameraScreen> createState() => _WebCameraScreenState();
}

class _WebCameraScreenState extends State<WebCameraScreen> {
  CameraController? _controller;
  bool _recording = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        setState(() => _error = 'Không tìm thấy camera.');
        return;
      }
      final c = CameraController(cams.first, ResolutionPreset.medium,
          enableAudio: widget.video);
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (e) {
      if (mounted) setState(() => _error = 'Không mở được camera: $e');
    }
  }

  Future<void> _shutter() async {
    final c = _controller;
    if (c == null) return;
    try {
      if (!widget.video) {
        final f = await c.takePicture();
        if (mounted) Navigator.pop(context, f);
      } else if (!_recording) {
        await c.startVideoRecording();
        setState(() => _recording = true);
      } else {
        final f = await c.stopVideoRecording();
        if (mounted) Navigator.pop(context, f);
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Lỗi: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      appBar: AppBar(title: Text(widget.video ? 'Quay video' : 'Chụp ảnh')),
      body: _error != null
          ? Center(child: Padding(
              padding: const EdgeInsets.all(16), child: Text(_error!)))
          : c == null || !c.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  Expanded(child: Center(child: CameraPreview(c))),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    backgroundColor: _recording ? Colors.red : null,
                    onPressed: _shutter,
                    child: Icon(!widget.video
                        ? Icons.camera_alt
                        : (_recording ? Icons.stop : Icons.videocam)),
                  ),
                  const SizedBox(height: 24),
                ]),
    );
  }
}