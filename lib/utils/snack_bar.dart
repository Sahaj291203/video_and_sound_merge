import 'package:flutter/material.dart';
import 'package:interview_task/widgets/text.dart';

import '../constants/colors.dart';

void showSuccessToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: MediaQuery.of(context).viewPadding.bottom + 20,
      left: 18,
      right: 18,
      child: _AnimatedSnackBar(
        message: message,
        color: successColor,
        type: 'Success',
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

void showErrorToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: MediaQuery.of(context).viewPadding.bottom + 20,
      left: 18,
      right: 18,
      child: _AnimatedSnackBar(
        message: message,
        color: Theme.of(context).colorScheme.error,
        type: 'Error',
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

class _AnimatedSnackBar extends StatefulWidget {
  final String message;
  final Color? color;
  final String type;
  _AnimatedSnackBar({required this.message, this.color, required this.type});

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  widget.type == 'Success'
                      ? Icons.check_circle_rounded
                      : Icons.error_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: CustomText(
                    text: widget.message,
                    size: 14,
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
