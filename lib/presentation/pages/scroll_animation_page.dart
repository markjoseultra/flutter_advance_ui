import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScorllAnimationPage extends StatefulWidget {
  const ScorllAnimationPage({super.key});

  @override
  State<ScorllAnimationPage> createState() => _ScorllAnimationPageState();
}

class _ScorllAnimationPageState extends State<ScorllAnimationPage> {
  final ScrollController _scrollController = ScrollController();

  final _textStyle = const TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [
          FadeInItem(
            key: const Key('001'),
            child: FullScreenListItem(
              child: Text(
                "Welcome",
                style: _textStyle,
              ),
            ),
          ),
          FullScreenListItem(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Slide In",
                  style: _textStyle,
                ),
                SlideInItem(
                  key: const Key('002'),
                  child: Text(
                    "Viola!",
                    style: _textStyle,
                  ),
                ),
              ],
            ),
          ),
          FadeInItem(
            key: const Key('003'),
            child: FullScreenListItem(
              child: Text(
                "Fade In",
                style: _textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenListItem extends StatelessWidget {
  final Widget child;
  const FullScreenListItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: child,
      ),
    );
  }
}

class FadeInItem extends StatefulWidget {
  final Widget child;
  const FadeInItem({super.key, required this.child});

  @override
  State<FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<FadeInItem> {
  double _opacity = 0.0;

  void init() {
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 3),
      child: widget.child,
    );
  }
}

class SlideInItem extends StatefulWidget {
  final Widget child;

  const SlideInItem({super.key, required this.child});

  @override
  State<SlideInItem> createState() => _SlideInItemState();
}

class _SlideInItemState extends State<SlideInItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _offsetAnimation;

  @override
  void dispose() {
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(3.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("SLIDE_IN_${widget.key}"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.10) {
          _controller.forward();
        } else {
          _controller.reset();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}
