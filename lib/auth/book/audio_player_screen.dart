import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'book_model.dart';

abstract class AudioPlayerState {}
class AudioPlayerInitial extends AudioPlayerState {}
class AudioPlayerLoaded extends AudioPlayerState {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;

  AudioPlayerLoaded({
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
  });
}

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  String? _currentUrl;
  bool _isUrlSet = false;

  AudioPlayerCubit() : super(AudioPlayerInitial());

  void initPlayer(String url) {
    _currentUrl = url;

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (state is AudioPlayerLoaded && !isClosed) {
        final currentState = state as AudioPlayerLoaded;
        emit(AudioPlayerLoaded(
          isPlaying: currentState.isPlaying,
          currentPosition: position,
          totalDuration: currentState.totalDuration,
          playbackSpeed: currentState.playbackSpeed,
        ));
      }
    });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      if (state is AudioPlayerLoaded && !isClosed) {
        final currentState = state as AudioPlayerLoaded;
        emit(AudioPlayerLoaded(
          isPlaying: playerState.playing,
          currentPosition: currentState.currentPosition,
          totalDuration: currentState.totalDuration,
          playbackSpeed: currentState.playbackSpeed,
        ));
      }
    });

    emit(AudioPlayerLoaded(
      isPlaying: false,
      currentPosition: Duration.zero,
      totalDuration: const Duration(minutes: 3),
      playbackSpeed: 1.0,
    ));
  }

  void togglePlay() async {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;

      if (!_isUrlSet && _currentUrl != null) {
        try {
          await _audioPlayer.setAsset(_currentUrl!);
          _isUrlSet = true;
          
          if (_audioPlayer.duration != null && !isClosed) {
            emit(AudioPlayerLoaded(
              isPlaying: currentState.isPlaying,
              currentPosition: currentState.currentPosition,
              totalDuration: _audioPlayer.duration!,
              playbackSpeed: currentState.playbackSpeed,
            ));
          }
        } catch (e) {
          debugPrint("Error loading audio: $e");
        }
      }

      if (currentState.isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    }
  }

  void changeSpeed() {
    if (state is AudioPlayerLoaded && !isClosed) {
      final currentState = state as AudioPlayerLoaded;
      double newSpeed = currentState.playbackSpeed + 0.25;
      if (newSpeed > 2.0) newSpeed = 1.0;
      _audioPlayer.setSpeed(newSpeed);
      emit(AudioPlayerLoaded(
        isPlaying: currentState.isPlaying,
        currentPosition: currentState.currentPosition,
        totalDuration: currentState.totalDuration,
        playbackSpeed: newSpeed,
      ));
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
class AudioPlayerScreen extends StatelessWidget {
  final BookModel book;

  const AudioPlayerScreen({super.key, required this.book});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerCubit()..initPlayer(book.audioUrl),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          builder: (context, state) {
            if (state is AudioPlayerInitial) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFD2E8BE)));
            } else if (state is AudioPlayerLoaded) {
              final currentPos = state.currentPosition;
              final totalDur = state.totalDuration;

              String formatDuration(Duration d) {
                String minutes = d.inMinutes.toString().padLeft(2, '0');
                String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
                return '$minutes:$seconds';
              }

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              book.image,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.grey.shade900,
                                child: const Icon(Icons.book, color: Colors.grey, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'By ${book.author}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: const Color(0xFFD2E8BE),
                          inactiveTrackColor: Colors.grey.shade800,
                          thumbColor: const Color(0xFFD2E8BE),
                        ),
                        child: Slider(
                          value: currentPos.inMilliseconds.toDouble().clamp(0.0, totalDur.inMilliseconds.toDouble()),
                          max: totalDur.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            context.read<AudioPlayerCubit>().seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(currentPos), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            Text('-${formatDuration(totalDur - currentPos)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                                            const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shuffle, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: Colors.white, size: 24),
                            onPressed: () {
                              final newPos = currentPos - const Duration(seconds: 10);
                              context.read<AudioPlayerCubit>().seek(newPos < Duration.zero ? Duration.zero : newPos);
                            },
                          ),
                          GestureDetector(
                            onTap: () => context.read<AudioPlayerCubit>().togglePlay(),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD2E8BE),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                state.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10, color: Colors.white, size: 24),
                            onPressed: () {
                              final newPos = currentPos + const Duration(seconds: 10);
                              context.read<AudioPlayerCubit>().seek(newPos > totalDur ? totalDur : newPos);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.brightness_3_outlined, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                          GestureDetector(
                            onTap: () => context.read<AudioPlayerCubit>().changeSpeed(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${state.playbackSpeed}x',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A1D26),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Readings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.open_in_full, color: Colors.grey.shade400, size: 16),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    book.description,
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}