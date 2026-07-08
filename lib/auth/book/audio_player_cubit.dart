import 'package:flutter_bloc/flutter_bloc.dart';

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
  AudioPlayerCubit() : super(AudioPlayerInitial());

  void initPlayer() {
    emit(AudioPlayerLoaded(
      isPlaying: false,
      currentPosition: Duration.zero,
      totalDuration: const Duration(minutes: 2),
      playbackSpeed: 1.0,
    ));
  }

  void togglePlay() {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      emit(AudioPlayerLoaded(
        isPlaying: !currentState.isPlaying,
        currentPosition: currentState.currentPosition,
        totalDuration: currentState.totalDuration,
        playbackSpeed: currentState.playbackSpeed,
      ));
    }
  }

  void changeSpeed() {
    if (state is AudioPlayerLoaded) {
      final currentState = state as AudioPlayerLoaded;
      double newSpeed = currentState.playbackSpeed + 0.25;
      if (newSpeed > 2.0) newSpeed = 1.0;
      emit(AudioPlayerLoaded(
        isPlaying: currentState.isPlaying,
        currentPosition: currentState.currentPosition,
        totalDuration: currentState.totalDuration,
        playbackSpeed: newSpeed,
      ));
    }
  }
}
