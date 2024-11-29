import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final AudioPlayer _audioPLayer = AudioPlayer();
  Timer? _timer;
  int _remainingTime = 0;
  bool _isRunning = false;

  final Map<String, int> _durations = {
    '30 seconds': 30,
    '1 minute': 60,
    '5 minutes': 300,
    '15 minutes': 900,
  };
  String _selectedDurationLabel = '1 minute';

  final Map<String, String> _musicFiles = {
    'Relaxing Sound': 'assets/songs/song1.mp3',
    'Nature Sound': 'assets/songs/song2.mp3',
    'Soft Piano': 'assets/songs/song3.mp3'
  };

  String _selectedMusicLabel = 'Relaxing Sound';

  @override
  void dispose() {
    _audioPLayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _remainingTime = _durations[_selectedDurationLabel]!;
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _stopTimer();
        _showCompletedDialog();
      }
    });

    //Play the selected background music
    _playMusic();
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _audioPLayer.pause();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _reserTimer() {
    _pauseTimer();
    setState(() {
      _remainingTime = _durations[_selectedDurationLabel]!;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _audioPLayer.stop();
    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _playMusic() async {
    try {
      await _audioPLayer.setAsset(_musicFiles[_selectedMusicLabel]!);
      _audioPLayer.play();
    } catch (e) {
      print("Error playing music: $e");
    }
  }

  void _showCompletedDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Session Complete'),
              content: const Text('Your meditation session has ended.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _reserTimer();
                  },
                  child: const Text('OK'),
                )
              ],
            ));
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Meditation Timer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Control your breathing",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/Images/meditation1.png',
                height: 150, width: 150, fit: BoxFit.cover),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Choose a duration for your session:",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
                value: _selectedDurationLabel,
                items: _durations.keys.map((label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.deepPurple),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (!_isRunning) {
                    setState(() {
                      _selectedDurationLabel = value!;
                      _remainingTime = _durations[_selectedDurationLabel]!;
                    });
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select Background Music:",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
                value: _selectedMusicLabel,
                items: _musicFiles.keys.map((label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.deepPurple),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMusicLabel = value!;
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: Text(
                _formatTime(_remainingTime),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isRunning ? Colors.orange : Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  icon: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isRunning ? 'Pause' : 'Start',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: _reserTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
