import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'web_camera_screen.dart';

class VideoRecorderHome extends StatefulWidget {
  const VideoRecorderHome({super.key});
  @override
  State<VideoRecorderHome> createState() => _VideoRecorderHomeState();
}

class _VideoRecorderHomeState extends State<VideoRecorderHome> {
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();

  Future<void> _ask(Permission p) async {
    if (kIsWeb) return; // Chrome tự hỏi quyền
    if (await p.isDenied) await p.request();
  }

  Future<void> _loadVideo(String path) async {
    await _controller?.dispose();
    final c = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(path))
        : VideoPlayerController.file(File(path));
    await c.initialize();
    c.play();
    if (!mounted) return;
    setState(() => _controller = c);
  }

  Future<void> _pickFromGallery() async {
    await _ask(Permission.photos);
    final f = await _picker.pickVideo(source: ImageSource.gallery);
    if (f != null) await _loadVideo(f.path);
  }

  Future<void> _recordFromCamera() async {
    if (kIsWeb) {
      // Chrome: dùng màn hình camera riêng
      final XFile? f = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (_) => const WebCameraScreen(video: true)),
      );
      if (f != null) await _loadVideo(f.path);
      return;
    }
    // Android/iOS: vẫn dùng image_picker như cũ
    await _ask(Permission.camera);
    await _ask(Permission.microphone);
    final f = await _picker.pickVideo(source: ImageSource.camera);
    if (f != null) await _loadVideo(f.path);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    return Scaffold(
      appBar: AppBar(title: const Text('Video Recorder & Playback')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ready
                ? AspectRatio(
                    aspectRatio: c.value.aspectRatio,
                    child: VideoPlayer(c),
                  )
                : const SizedBox(
                    height: 200,
                    child: Center(child: Text('Chưa có video nào được chọn.')),
                  ),
            const SizedBox(height: 20),
            if (ready)
              ElevatedButton(
                onPressed: () =>
                    setState(() => c.value.isPlaying ? c.pause() : c.play()),
                child: Icon(c.value.isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFromGallery,
              child: const Text('Chọn video từ Gallery'),
            ),
            ElevatedButton(
              onPressed: _recordFromCamera,
              child: const Text('Quay video từ Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
