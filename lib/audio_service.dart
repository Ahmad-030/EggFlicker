// lib/services/audio_service.dart
//
// Music plays only while the app is in the foreground.
// No background service is used – AppLifecycleListener pauses/resumes the
// player automatically, which is the simplest correct approach.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService with WidgetsBindingObserver {
  AudioService._();
  static final AudioService instance = AudioService._();

  static const _prefKey = 'music_enabled';

  final AudioPlayer _bgPlayer = AudioPlayer();
  bool _musicEnabled = true;
  bool _initialized = false;

  bool get musicEnabled => _musicEnabled;

  /// Call once from main() or first screen.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool(_prefKey) ?? true;

    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(0.6);

    // Pause/resume when app goes to background / foreground
    WidgetsBinding.instance.addObserver(this);

    if (_musicEnabled) await _startMusic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_musicEnabled) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _bgPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      _bgPlayer.resume();
    }
  }

  Future<void> _startMusic() async {
    // Replace with your actual asset path, e.g. 'audio/bg_music.mp3'
    try {
      await _bgPlayer.play(AssetSource('music.mp3'));
    } catch (_) {
      // Asset not bundled yet – silently skip in dev
    }
  }

  Future<void> toggleMusic() async {
    _musicEnabled = !_musicEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _musicEnabled);

    if (_musicEnabled) {
      await _startMusic();
    } else {
      await _bgPlayer.stop();
    }
  }

  Future<void> pauseMusic() async {
    if (_musicEnabled) await _bgPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (_musicEnabled) await _bgPlayer.resume();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bgPlayer.dispose();
  }
}