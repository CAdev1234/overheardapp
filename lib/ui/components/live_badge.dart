import 'package:flutter/material.dart';

class LiveBadge extends StatefulWidget {
  final Color bgColor;
  final double width;
  final int milliSecond;
  const LiveBadge({
    Key? key,
    required this.width,
    required this.bgColor,
    required this.milliSecond
  }) : super(key: key);

  @override
  createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _tween = Tween(
      begin: 0,
      end: 1
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.milliSecond)
    )..addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat(reverse: true);
      }
    });
    _animation = _tween.animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FadeTransition(
      opacity: _animation,
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