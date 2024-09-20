import 'package:flutter/material.dart';

class PageViewAnimation extends StatefulWidget {
  const PageViewAnimation({super.key});

  @override
  State<PageViewAnimation> createState() => _PageViewAnimationState();
}

class _PageViewAnimationState extends State<PageViewAnimation> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: const [
              PageViewItem(
                child: Text("First Page"),
              ),
              PageViewItem(
                child: Text("First Page"),
              ),
              PageViewItem(
                child: Text("First Page"),
              ),
              PageViewItem(
                child: Text("First Page"),
              ),
              PageViewItem(
                child: Text("First Page"),
              ),
              PageViewItem(
                child: Text("First Page"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PageViewItem extends StatefulWidget {
  final Widget child;
  const PageViewItem({super.key, required this.child});

  @override
  State<PageViewItem> createState() => _PageViewItemState();
}

class _PageViewItemState extends State<PageViewItem> {
  ObjectPositions object1Pos =
      ObjectPositions(top: 0, bottom: null, left: -200, right: null);

  ObjectPositions object2Pos =
      ObjectPositions(top: null, bottom: 0, left: null, right: -200);

  Widget objectPlaceholder() {
    return Container(
      height: 100,
      width: 200,
      color: Colors.blue,
    );
  }

  void initAnimation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      object1Pos = ObjectPositions(top: 0, bottom: null, left: 0, right: null);
      object2Pos = ObjectPositions(top: null, bottom: 0, left: null, right: 0);
    });
  }

  @override
  void initState() {
    initAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          curve: Curves.bounceOut,
          duration: const Duration(seconds: 2),
          top: object2Pos.top,
          left: object2Pos.left,
          right: object2Pos.right,
          bottom: object2Pos.bottom,
          child: objectPlaceholder(),
        ),
        AnimatedPositioned(
          curve: Curves.bounceOut,
          duration: const Duration(seconds: 2),
          top: object1Pos.top,
          left: object1Pos.left,
          right: object1Pos.right,
          bottom: object1Pos.bottom,
          child: objectPlaceholder(),
        ),
        Center(
          child: widget.child,
        ),
      ],
    );
  }
}

class ObjectPositions {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  ObjectPositions({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
}
