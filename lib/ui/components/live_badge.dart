import 'package:flutter/material.dart';

class LiveBadge extends StatefulWidget {
  final Color bgColor;
  final double width;
  const LiveBadge({
    Key? key,
    required this.width,
    required this.bgColor
  }) : super(key: key);

  @override
  createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge> with TickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _tween = Tween(
      begin: 0.5,
      end: 0.5
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700)
    );
    _controller.repeat(reverse: true);
    _animation = _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.width,
        height: widget.width,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
    );
  }
}