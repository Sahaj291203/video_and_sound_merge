import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_task/constants/api.dart';
import 'package:interview_task/cubit/sound_cubit/sound_state.dart';
import 'package:interview_task/model/sound_model.dart';
import 'package:interview_task/services/api_service.dart';
import 'package:interview_task/services/video_merge_service.dart';
import 'package:video_player/video_player.dart';

class SoundCubit extends Cubit<SoundState> {
  SoundCubit() : super(SoundState()) {
    fetchSounds();
  }

  Future<void> pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    Future.delayed(
      Duration(seconds: 1),
      () => emit(state.copyWith(isInitializingVideo: true)),
    );
    final picked = await picker.pickVideo(
      source: source,
      maxDuration: Duration(seconds: 30),
    );
    if (picked != null) {
      final file = File(picked.path);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 50) {
        emit(
          state.copyWith(
            videoSizeError: "Video is too large. Max size allowed is 50MB.",
            isInitializingVideo: false,
          ),
        );
        return;
      }
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      controller.setLooping(true);
      controller.play();

      emit(
        state.copyWith(
          videoFile: file.path,
          videoController: controller,
          isVideoPlaying: true,
          isVideoMerged: false,
          isInitializingVideo: false,
        ),
      );
    } else {
      emit(state.copyWith(isInitializingVideo: false));
    }
  }

  void clearVideo() {
    state.videoController?.pause();
    state.videoController?.dispose();

    emit(
      state.copyWith(
        videoFile: "null",
        videoController: state.videoController,
        isVideoPlaying: false,
        isVideoMerged: false,
        isInitializingVideo: false,
        videoSizeError: null,
      ),
    );
  }

  void togglePlayPause() {
    final controller = state.videoController;
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
      emit(state.copyWith(isVideoPlaying: false));
    } else {
      controller.play();
      emit(state.copyWith(isVideoPlaying: true));
    }
  }

  void selectSound(SoundList sound) {
    emit(
      state.copyWith(
        audioUrl: "${Api.baseAudioPath}${sound.sound}",
        selectedSound: sound,
      ),
    );
  }

  void clearSelectedSound() {
    emit(state.copyWith(audioUrl: "null", selectedSound: null));
  }

  Future<void> fetchSounds() async {
    try {
      emit(state.copyWith(isLoading: true));
      final audios = await ApiService.fetchAudioUrls();
      emit(state.copyWith(audioList: audios.data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<bool> mergeAndSave() async {
    if (state.videoFile == null || state.audioUrl == null) return false;
    try {
      emit(state.copyWith(isMerging: true));
      const downloadsFolderPath = '/storage/emulated/0/Download/shReels';
      final Directory downloadDir = Directory(downloadsFolderPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      final outputPath =
          "${downloadDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.mp4";
      print("Path:::$outputPath");

      final success = await VideoMergeService.mergeVideoWithAudio(
        videoPath: state.videoFile!,
        audioUrl: state.audioUrl!,
        outputPath: outputPath,
      );

      emit(
        state.copyWith(
          videoFile: "null",
          audioUrl: "null",
          isMerging: false,
          isVideoMerged: success,
        ),
      );
      state.videoController?.dispose();
      return success;
    } catch (e) {
      emit(state.copyWith(isMerging: false, mergeError: e.toString()));
      return false;
    }
  }

  @override
  Future<void> close() {
    state.videoController?.dispose();
    return super.close();
  }
}
