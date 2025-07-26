import 'package:flutter/material.dart';
import 'package:interview_task/constants/colors.dart';
import 'package:interview_task/model/sound_model.dart';
import 'package:interview_task/router/router.dart';

import '../widgets/network_image.dart';
import '../widgets/text.dart';

class SoundListView extends StatefulWidget {
  final SoundData data;
  const SoundListView({super.key, required this.data});

  @override
  State<SoundListView> createState() => _SoundListViewState();
}

class _SoundListViewState extends State<SoundListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "${widget.data.soundCategoryName} (Sounds)" ?? "",
          color: Theme.of(context).colorScheme.surface,
          size: 18,
        ),
        centerTitle: true,
      ),
      body: widget.data.soundList!.isEmpty
          ? Center(
              child: Text(
                'No Sounds Available',
                style: TextStyle(fontSize: 15),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  CustomText(text: "Select the sound", size: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.data.soundList?.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      itemBuilder: (_, index) {
                        final sounds = widget.data.soundList![index];

                        return soundsList(sounds);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget soundsList(SoundList sounds) {
    return InkWell(
      onTap: () {
        AppRouter.navigatorKey.currentState?.pop(sounds);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: NetworkImageWidget(
                image: sounds.soundImage ?? "",
                height: 70,
                width: 70,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: sounds.soundTitle ?? "",
                    size: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    text: sounds.singer ?? "",
                    size: 15,
                    color: darkGreyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
