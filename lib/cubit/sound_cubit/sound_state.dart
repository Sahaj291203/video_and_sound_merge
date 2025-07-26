import 'package:interview_task/model/sound_model.dart';
import 'package:video_player/video_player.dart';

class SoundState {
  final String? videoFile;
  final String? audioUrl;
  final List<SoundData> audioList;
  final bool isLoading;
  final bool isMerging;
  final String? error;
  final String? mergeError;
  final String? videoSizeError;
  final bool isVideoPlaying;
  final bool isVideoMerged;
  final bool isInitializingVideo;
  final VideoPlayerController? videoController;
  final SoundList? selectedSound;

  SoundState({
    this.videoFile = "null",
    this.audioUrl,
    this.audioList = const [],
    this.isLoading = false,
    this.isMerging = false,
    this.error,
    this.mergeError,
    this.videoSizeError,
    this.isVideoPlaying = false,
    this.isVideoMerged = false,
    this.isInitializingVideo = false,
    this.videoController,
    this.selectedSound,
  });

  SoundState copyWith({
    String? videoFile,
    String? audioUrl,
    List<SoundData>? audioList,
    bool? isLoading,
    bool? isMerging,
    String? error,
    String? mergeError,
    String? videoSizeError,
    bool? isVideoPlaying,
    bool? isVideoMerged,
    bool? isInitializingVideo,
    VideoPlayerController? videoController,
    SoundList? selectedSound,
  }) {
    return SoundState(
      videoFile: videoFile ?? this.videoFile,
      audioUrl: audioUrl ?? this.audioUrl,
      audioList: audioList ?? this.audioList,
      isLoading: isLoading ?? this.isLoading,
      isMerging: isMerging ?? this.isMerging,
      error: error,
      mergeError: mergeError,
      videoSizeError: videoSizeError,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      isVideoMerged: isVideoMerged ?? this.isVideoMerged,
      isInitializingVideo: isInitializingVideo ?? this.isInitializingVideo,
      videoController: videoController ?? this.videoController,
      selectedSound: selectedSound ?? this.selectedSound,
    );
  }
}
