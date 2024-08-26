import 'package:flutter/material.dart';

class PageInitAnimationValues {
  final AnimationController controller;
  final Animation<double> barHeight;
  final Animation<double> avatarSize;
  final Animation<double> titleOpacity;
  final Animation<double> textOpacity;

  PageInitAnimationValues({required this.controller})
      : barHeight = Tween<double>(begin: 0, end: 250).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 0.30, curve: Curves.bounceOut),
          ),
        ),
        avatarSize = Tween<double>(begin: 0, end: 3).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.30, 0.60, curve: Curves.bounceOut),
          ),
        ),
        titleOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.60, 0.70, curve: Curves.easeIn),
          ),
        ),
        textOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.70, 1, curve: Curves.easeIn),
          ),
        );
}

class AnimatedBuilderDemoPage extends StatefulWidget {
  const AnimatedBuilderDemoPage({super.key});

  @override
  State<AnimatedBuilderDemoPage> createState() =>
      _AnimatedBuilderDemoPageState();
}

class _AnimatedBuilderDemoPageState extends State<AnimatedBuilderDemoPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late PageInitAnimationValues _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = PageInitAnimationValues(controller: _animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation.controller,
        builder: (context, child) {
          return _uiBuilder(
            context: context,
            child: child,
            size: size,
          );
        },
      ),
    );
  }

  Widget _uiBuilder({
    required BuildContext context,
    required Widget? child,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.blue,
                height: _animation.barHeight.value,
                width: double.infinity,
                child: const SizedBox(),
              ),
              Positioned(
                top: 220,
                left: size.width / 2 - 20,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(
                    _animation.avatarSize.value,
                    _animation.avatarSize.value,
                    1.0,
                  ),
                  child: const CircleAvatar(
                    child: Text(
                      "M",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 90),
        Opacity(
          opacity: _animation.titleOpacity.value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: size.width / 2,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const SizedBox(),
            ),
          ),
        ),
        Opacity(
          opacity: _animation.titleOpacity.value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
