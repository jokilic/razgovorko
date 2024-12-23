import 'package:flutter/material.dart';

import '../constants/durations.dart';

class RazgovorkoButton extends StatefulWidget {
  final Widget child;
  final Function()? onPressed;
  final Function()? onLongPressed;

  const RazgovorkoButton({
    required this.child,
    this.onPressed,
    this.onLongPressed,
    super.key,
  });

  @override
  State<RazgovorkoButton> createState() => _RazgovorkoButtonState();
}

class _RazgovorkoButtonState extends State<RazgovorkoButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: RazgovorkoDurations.buttonScaleDuration,
    );

    animation = Tween<double>(begin: 1, end: 0.95).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> onTapDown(TapDownDetails details) async {
    await controller.forward();
  }

  Future<void> onTapUp(TapUpDetails details) async {
    await controller.forward();
    await controller.reverse();

    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  Future<void> onTapCancel() async {
    await controller.reverse();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: widget.onPressed != null || widget.onLongPressed != null ? onTapDown : null,
        onTapUp: widget.onPressed != null || widget.onLongPressed != null ? onTapUp : null,
        onTapCancel: widget.onPressed != null || widget.onLongPressed != null ? onTapCancel : null,
        onLongPress: widget.onLongPressed,
        child: AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.scale(
            scale: animation.value,
            child: child,
          ),
          child: widget.child,
        ),
      );
}
