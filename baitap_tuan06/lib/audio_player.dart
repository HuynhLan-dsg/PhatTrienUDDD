import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerHome extends StatefulWidget {
  const AudioPlayerHome({super.key});
  @override
  State<AudioPlayerHome> createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome> {
  final AudioPlayer _player = AudioPlayer();
  final List<String> _files = ['audios/sample1.mp3', 'audios/sample2.mp3', 'audios/sample3.mp3'];
  final List<String> _titles = ['Sample 1', 'Sample 2', 'Sample 3'];
  final List<String> _artists = ['Artist A', 'Artist B', 'Artist C'];

  int _index = 0;
  PlayerState _state = PlayerState.stopped;
  Duration _pos = Duration.zero, _dur = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) => setState(() => _state = s));
    _player.onPositionChanged.listen((p) => setState(() => _pos = p));
    _player.onDurationChanged.listen((d) => setState(() => _dur = d));
    _player.onPlayerComplete.listen((_) => _next());
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(int i) async {
    setState(() {
      _index = i;
      _pos = Duration.zero;
    });
    await _player.stop();
    await _player.play(AssetSource(_files[i]));
  }

  Future<void> _toggle() async {
    if (_state == PlayerState.playing) {
      await _player.pause();
    } else if (_state == PlayerState.paused) {
      await _player.resume();
    } else {
      await _play(_index);
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    setState(() => _pos = Duration.zero);
  }

  void _next() => _play((_index + 1) % _files.length);
  void _prev() => _play((_index - 1 + _files.length) % _files.length);

  String _fmt(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final playing = _state == PlayerState.playing;
    final maxSec = _dur.inSeconds > 0 ? _dur.inSeconds.toDouble() : 1.0;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E0E6B), Color(0xFF2B0A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              title: const Text('ALBUM'),
              centerTitle: true,
            ),
            const SizedBox(height: 12),
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                iconSize: 80,
                color: const Color(0xFF8E0E6B),
                icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                onPressed: _toggle,
              ),
            ),
            const SizedBox(height: 16),
            Text(_titles[_index],
                style: const TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(_artists[_index], style: const TextStyle(color: Colors.white70)),
            Slider(
              min: 0,
              max: maxSec,
              value: _pos.inSeconds.toDouble().clamp(0, maxSec),
              activeColor: Colors.pinkAccent,
              onChanged: (v) => _player.seek(Duration(seconds: v.toInt())),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_fmt(_pos), style: const TextStyle(color: Colors.white70)),
                  Text(_fmt(_dur), style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(iconSize: 40, color: Colors.white,
                  icon: const Icon(Icons.skip_previous), onPressed: _prev),
              IconButton(iconSize: 48, color: Colors.white,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: _toggle),
              IconButton(iconSize: 40, color: Colors.white,
                  icon: const Icon(Icons.stop), onPressed: _stop),
              IconButton(iconSize: 40, color: Colors.white,
                  icon: const Icon(Icons.skip_next), onPressed: _next),
            ]),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: _files.length,
                itemBuilder: (_, i) => ListTile(
                  selected: i == _index,
                  selectedColor: Colors.pinkAccent,
                  textColor: Colors.white,
                  leading: Text('${i + 1}.'),
                  title: Text(_titles[i]),
                  subtitle: Text(_artists[i],
                      style: const TextStyle(color: Colors.white54)),
                  onTap: () => _play(i),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}