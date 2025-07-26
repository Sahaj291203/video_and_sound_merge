import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_task/constants/colors.dart';
import 'package:interview_task/constants/device_size.dart';
import 'package:interview_task/cubit/sound_cubit/sound_cubit.dart';
import 'package:interview_task/cubit/sound_cubit/sound_state.dart';
import 'package:interview_task/model/sound_model.dart';
import 'package:interview_task/router/router.dart';
import 'package:interview_task/utils/snack_bar.dart';
import 'package:interview_task/widgets/button.dart';
import 'package:interview_task/widgets/loader.dart';
import 'package:interview_task/widgets/network_image.dart';
import 'package:interview_task/widgets/text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.videos.request();
    } else if (Platform.isIOS) {
      await Permission.photos.request();
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoundCubit>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Video Merger",
          color: Theme.of(context).colorScheme.surface,
          size: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SoundCubit, SoundState>(
        listener: (context, state) {
          if (state.videoSizeError != null) {
            showErrorToast(
              context,
              state.videoSizeError ?? "Video is too large.",
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                videoPickersButtons(),
                const SizedBox(height: 20),
                if (state.isInitializingVideo)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight(context) * 0.25,
                            maxWidth: screenWidth(context),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: darkGreyColor.withOpacity(0.5),
                            highlightColor: whiteColor.withOpacity(0.5),
                            child: Container(color: darkGreyColor),
                          ),
                        ),
                        CustomText(text: 'Video is Loading...'),
                      ],
                    ),
                  ),
                if (state.videoFile != "null" &&
                    state.videoController != null &&
                    state.videoController!.value.isInitialized &&
                    !state.isVideoMerged &&
                    !state.isInitializingVideo) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight(context) * 0.25,
                        maxWidth: screenWidth(context) * 1,
                      ),
                      child: VideoPlayer(state.videoController!),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          state.isVideoPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          context.read<SoundCubit>().togglePlayPause();
                        },
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          Icons.cancel_rounded,
                          size: 60,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          context.read<SoundCubit>().clearVideo();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],

                if (state.isLoading) ...[
                  Expanded(child: LoaderWidget()),
                ] else if (state.error != null) ...[
                  Expanded(child: Center(child: Text(state.error.toString()))),
                ] else ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.audioList.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemBuilder: (_, i) {
                        final soundCategory = state.audioList[i];
                        return soundCategoryCard(soundCategory);
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocConsumer<SoundCubit, SoundState>(
        listener: (context, state) {
          if (state.mergeError != null) {
            showErrorToast(context, state.mergeError ?? "Failed to Merged");
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.audioUrl != "null" &&
                    state.selectedSound != null) ...[
                  selectedAudioWidget(state.selectedSound ?? SoundList()),
                ],
                CustomButton(
                  isLoading: state.isMerging,
                  onTap:
                      (state.videoFile != "null" &&
                          state.audioUrl != "null" &&
                          !state.isMerging &&
                          !state.isVideoMerged)
                      ? () async {
                          final success = await cubit.mergeAndSave();
                          if (success) {
                            showSuccessToast(
                              context,
                              "Merged & Saved Successfully",
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget videoPickersButtons() {
    final cubit = context.read<SoundCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => cubit.pickVideo(ImageSource.gallery),
          icon: Icon(Icons.image),
          label: CustomText(
            text: "Select Video",
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => cubit.pickVideo(ImageSource.camera),
          icon: Icon(Icons.camera_alt_rounded),
          label: CustomText(
            text: "Capture Video",
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget soundCategoryCard(SoundData soundCategory) {
    return InkWell(
      onTap: () async {
        final cubit = context.read<SoundCubit>();
        final controller = cubit.state.videoController;
        if (controller != null && controller.value.isPlaying) {
          cubit.togglePlayPause();
        }
        final value = await AppRouter.navigatorKey.currentState?.pushNamed(
          AppRouter.soundList,
          arguments: soundCategory,
        );
        if (value != null) {
          final sound = value as SoundList;
          cubit.selectSound(sound);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: NetworkImageWidget(
                image: soundCategory.soundCategoryProfile ?? "",
                height: screenWidth(context) * 0.25,
                width: screenWidth(context) * 0.3,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CustomText(
                text: soundCategory.soundCategoryName ?? "",
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectedAudioWidget(SoundList selectSound) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            CustomText(
              text: "Selected Audio",
              size: 18,
              fontWeight: FontWeight.w900,
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                final cubit = context.read<SoundCubit>();
                cubit.clearSelectedSound();
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: NetworkImageWidget(
                image: selectSound.soundImage ?? "",
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: selectSound.soundTitle ?? "",
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: selectSound.sound ?? "",
                    size: 12,
                    color: darkGreyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
