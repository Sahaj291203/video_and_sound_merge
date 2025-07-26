import 'package:flutter/material.dart';
import 'package:interview_task/constants/colors.dart';
import 'package:interview_task/widgets/loader.dart';
import 'package:interview_task/widgets/text.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final Function()? onTap;
  const CustomButton({super.key, this.isLoading = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
      child: isLoading
          ? LoaderWidget(color: Theme.of(context).colorScheme.surface)
          : CustomText(
              text: 'Merged & Save',
              color: onTap != null
                  ? Theme.of(context).colorScheme.surface
                  : darkGreyColor,
            ),
    );
  }
}
